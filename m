Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AEADCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E3F6B0005; Thu, 11 Jun 2026 09:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25FA6B008C; Thu, 11 Jun 2026 09:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93B706B009F; Thu, 11 Jun 2026 09:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82B266B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:06:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 412F7162353
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:06:14 +0000 (UTC)
X-FDA: 84867655068.23.E986501
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012065.outbound.protection.outlook.com [40.107.209.65])
	by imf20.hostedemail.com (Postfix) with ESMTP id D25741C0002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:06:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=4YznSylr;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.65 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781183171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eQO7zgINNKZsiYp5nq4F4iy7c2ZCMmxiGWjMPq0oX2k=;
	b=25PDws2UHiSvcwx/f1HtzMyqlTUZLFSD2mrNfOR33mtTIAzO6EaD2po92FNyhfyR3dfiEt
	SE1pdjGTW84Yn+7+4XeXeTuFMYxpvMmAfOlJcN0xnexcUkoeAZnXDxXhe8E4kX7qvZjzO3
	oUh3AAFHRDEwKabhTiieSEUc6fGNtQ4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=4YznSylr;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.65 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781183171;
	b=26HgTr4xyg/HAr56fhEkD2ffl+AAgalkQ4YuRMJQdiKxOtZixMVGvuuxJRUivOxcXZWP20
	OxTtJ3ImVaVfVqOhyqJyUfmw7JK5c4CgTF7h33JFuUOSaHpav52xCfQcJKQuFMB5Hapt0g
	LlhHlnjnUSYiN8nfYND9wOFP5QWf/tg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MvlTaBu9KiKn4RfF+f22HvpI9djYBAiW+zP6ScGKFF00KrCxRcaYG/lu3Doi1EQlqusnXUJOge/9n1B64nRGsCN7bih8WN3psMoQOKorxNhUGudBZOlskf6VIk8WijimW2dr9A3JMP+YUuK8YnEmXgS04yQM8kqOxj3L0Lg4PQnYFlR2xFpxfOilr5JPk2a9faqdEtF43fb8OjzVh0LTmmTwGtnbfS8for0ohJyVo/Vec5MXx6huOQ1JHiYIqKFU0i5gzEe3yWzMgQwvzm/284tcpnrxCGTGWBXVpzXxv4BKsFgzaogYqE4BgKO8VqERpG+57aOBQajxx8Gr/YOu6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eQO7zgINNKZsiYp5nq4F4iy7c2ZCMmxiGWjMPq0oX2k=;
 b=TmlURwvA/G6VLMEIkRgUTU9tKyFVzZYHwKA9IGynPRNHHcneyyiM1bX6cSesZAjnzn/6JD+yQwJMiju8eS5s7ieTHA73sHKJhzmDzM6PGTKMZykTy09mEpi4f3JKZh6imdCy2Nje3PIx8VVveE6YKCNZyeOeuPsfRgGzoIZFenIhJjcFExq5TdqrT+g+ShUkcpYyNiHTxNRMX29HjMQOFaBxwyMO7Q1rVEHQ16Re7ZxlBuJW8UQRpBfa+BVwpMxw3yLgDAw+4cXpS7t8NZwTSbjknezazXYJzIl2MHqiZyOicy9m9mLcqyWLHb3XSU4tXmJbLWIgs+bWJpUSdXn9lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQO7zgINNKZsiYp5nq4F4iy7c2ZCMmxiGWjMPq0oX2k=;
 b=4YznSylrmvHWT3Bi/0gRPLA643If/ij9k21GuuPmfKPrchgBnx2MbhL9fmJzz6n46AFDUYj8PdvrX2bZYTA0FGU29Pw2r+ty2Ae5kyMDvjz6tCyFBxQtKueMJrLJtjiOoDqNuM5S0xl9LTezKKP2lFvSl+3y+/HRiXqr4jfIyrg=
Received: from BY3PR03CA0020.namprd03.prod.outlook.com (2603:10b6:a03:39a::25)
 by SN7PR12MB8769.namprd12.prod.outlook.com (2603:10b6:806:34b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Thu, 11 Jun
 2026 13:06:06 +0000
Received: from SJ5PEPF000001CB.namprd05.prod.outlook.com
 (2603:10b6:a03:39a:cafe::4) by BY3PR03CA0020.outlook.office365.com
 (2603:10b6:a03:39a::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.13 via Frontend Transport; Thu,
 11 Jun 2026 13:06:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF000001CB.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Thu, 11 Jun 2026 13:06:06 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 11 Jun
 2026 08:06:06 -0500
Received: from [127.0.1.1] (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 11 Jun
 2026 06:05:57 -0700
From: Shivank Garg <shivankg@amd.com>
Subject: [PATCH RFC 0/3] KVM: guest_memfd: folio migration for
 non-confidential VMs
Date: Thu, 11 Jun 2026 13:05:07 +0000
Message-ID: <20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIOyKmoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDM0ND3eKMzLLEvGzd9NzUXN3czPSixJJUXYtkw2RTQ8skY4NEMyWg1oK
 i1LTMCrCx0UpBbs5KsbW1AIAClyhrAAAA
X-Change-ID: 20260611-shivank-gmem-migrate-8c1c519b30a6
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
	<david@kernel.org>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Chao Peng
	<chao.p.peng@linux.intel.com>, Nikunj A Dadhania <nikunj@amd.com>, Ira Weiny
	<ira.weiny@intel.com>, Michael Roth <michael.roth@amd.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Ackerley Tng <ackerleytng@google.com>, Fuad Tabba
	<tabba@google.com>, Sean Christopherson <seanjc@google.com>, Vishal Annapurve
	<vannapurve@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, Patrick
 Roy <patrick.roy@linux.dev>, Pratik Sampat <prsampat@amd.com>, Ashish Kalra
	<Ashish.Kalra@amd.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781183157; l=2240;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=l9OhizZBliSH6176iirfCD0QxXUpxYCmVPS9IJnO3zs=;
 b=fyWLp9D+B/8tocZMXW/rxGICD365Q3/0VKP8FNBXloIxVWOcer3HHneMWjLmbuknLVzqkV4uT
 4aZ8Jz+9IQxADIo40ZcmTjeK8fSVaLMQR3EINQrddvYlbWVZOeUOYsd
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CB:EE_|SN7PR12MB8769:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d85cd26-e6b3-4e77-dce4-08dec7ba32ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|376014|36860700016|7416014|18002099003|921020|6133799003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	0VRLDm1PJKKNzJ7jmPiEBc8Guc2NNGyM7GdKQlrjV0n9G6ib/suis0vmG1d+w1WebaPYzQnNmNXgr1uih9miK0zaE988CHszo2IpM3LNTeacfXeHx/8ZLssjy7Prt1r2gz5TJ/hxUPc2Z+2E8AoeYqq8hHpyS/ScI02e+o4A7TcH5x/MSkfeIZgu7rukH2RZsv2fI+HWkOGZl8eBE4SswzUNe055Mw8StL+ojnp2huKXa1T79n7EzgGuhPkjz/kgo4LYA+b3ubuiI7N3fozRD9ArLvkOJSh0VGwPlDktxlGTqEYuIyIFeCPFVy8qY6ymV8289h1D0srzXBevfoT6dMdXLdX56YwFZvw5ajgxo3/AZIjDrKdRaAHViqDrhvGYnd0mcnY/DBtCx/Il86micOuBpsgWB1O9q2m7p6WDNlvSE5D3ozJxKzT1biw5aGGKwPBHpzzsFjlDImMNiU70xmlX/AWM1vfdGIZdUgMUx5/S9sM3If2VFCOhNB9NXGLhVU1P6sCMZdLM7iPlPqMIyhYK5epGbXkJZpWtLpCzxnn4Yw7fgdOCBSNvsuIZ4pn/y17/tCwl0hVwerjJGxs711vOBr1f3ntTcfcOiWOoUlSknEnBM1T9Br/FM5eQ6FfTXdAW5X0F72WqPLPYtZP0zBAShTzWVQhaDUbB96y0z2jjwlrua3R6v474dPA5vD8e2Cbe3oJIAfdAyg8GPhXc3gPRAvCYEvSkPO2Hyj0D5bfMg+Dlq4QOxMPbJzL3edUVMNeJsheld6LK7yokrvVLrFORlYlQMzxnLqnA1ZsSR44=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(376014)(36860700016)(7416014)(18002099003)(921020)(6133799003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/G2FJaV5/D57DMvsxlHWeYJS1zVE4fZJEoh7IdmfOpxtpNgGawlyewZqRIwNfvpNUr12yMav8+cptLkww3/guX+CacFFQtM+XUoRtHsBpSSBK3SKOQnq1U54C0opWpVYQv+K1hu+Z0Rxbb5cTCAVKuwgnICcK1jMJ/VTq/JGZubAG/ch00UDKlhXe8FittJXv9pYuFGG9eSa2t7SjfJxsB7KGvLDtzD6GPOb5I7ywRrA6pxLGsFEvYzu1KmXNYSatspBqdL0zf55salL5qbyiiV2Tv6l9YpSg8PlLCatrA3hRZnuoIxJ1C7nCE6z2YDAThvsj/iu/IkdCWgYR9ph+YR11uwruXn9gXlPtNmnonFERU9/DoKoxDD+GvuOLv9NvNPyjdWwQCWWFHeUyIfaboDyBeqPXu8GSu+myAWGiApJk3Z1/Trpj8vPnFgD0ATP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 13:06:06.4192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d85cd26-e6b3-4e77-dce4-08dec7ba32ea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8769
X-Rspamd-Queue-Id: D25741C0002
X-Rspam-User: 
X-Stat-Signature: xqjuigta4ryg6wnm7pzm4jtgdqxi6c1s
X-Rspamd-Server: rspam09
X-HE-Tag: 1781183170-217898
X-HE-Meta: U2FsdGVkX1/N53xkX+d7Q1derSe5e9C8TB1iv201sBRKGNnME2bSLuCW6jTvvPwPm2PdhL9vN8i4R3PB8U56JwHU5h0cRti/ySQ9duZm/QVcSQXqPhx1n8Mtp9DbRykg3Vlv16K6WBVft/BrxVYQMDjMW7qdMdt+n2CRpLa7Ph8LzFT9wHcPazc4FED9IheoL+9t+qNoWVN+mzOOKb3514uKsZumPnns1BsmHTmrOXMcnDTZUSD/BLr9AsmAPCX/Qeveq1iQdG4yDIDDuc/KrVsy596sB6IrUpKoZSvGFrsWx9sdFBpI8gzxTg1h59mTizmXpVgEEL+rIt2zx3FyeNhG7uWPMDU0UvQN1oUkZ0wWm0hXAa1Y5eAQJ7QBSiY2WyKQeGf0EUD4Bb451/dCuWE0O4MB/rZfbZKko32vZLW9IghI+MbKHmpU9GgHNLq/LMRXv1WqEUcZM6FSUvQjd2caQRBObc0ReAttSyUffDI3gjykuC9EZWxxiMBXkDM0b4p4zUao6/zUonBVBLKjp4MdSk0HmPxhTeV3pmHz+vrOwABiqDJe39asZDytuO+hMD24sKYq2d6MRwLuuz0itH7ohLWjZHHgfhuRBbzSyzZAwgN0foGcrBCcBtqw6YQ39BBM3eBqWb3H+I1g3rtpHQ/8GXHzt3H99VHN379l/0VQZ1mQZe5c32dD3BHEz1xiqv1mcGhJdw993LBkfC8zTCT38ZDoP70vUUe1vgMKfggSz/zJm2NE4U986ELfEE8Rk5xAoxyL2KJ4K2Xs8XX37kXXyZ47L1k9gtLAx/UKpz0bprxFmQG8y+OBVjctt21sVbFSeQcI1cnJsSRj3pajkIQU9Pitk/luLEmdw0pmVR1Kcrm85ksHXssbJuCPFw8L6HlAg8bLlmX3cIcjcmPu/GqoiE13zA3fKlZkIlQ50Ahg94qHtnQbmwoOZzT71PPEk+mepjsIewwmt+luWYU
 ocyUg4/8
 TSI8XwaFAEyVsRVF8XdgUL0/1HaMYPqZwHFapMTb0joBV/1sQ4nalVqHzr33SY7yTUtTNGbF31jp7wJXJpyhlhbcQ6DSojYpudYErG7DESS2+2vuR0jdanM5FNFBGQRmHUax47KeJta/hGuZ4eZA1eqNlrpBGYFf5qtgxrNtbkLld/giwnmYE4IT5WdxGsLDi8yrDC/rUfIbarXeFw9m3ywaIklXS1S61cXe1Xis9OnVdbQ3emrqjUICt1kFn3C2Lh6eytTBKoZczNDJ4vnH/tvLCiHItDkPGiIAnNX9vdQPPKF709ff8VJJ03pBXCCZ6Mda+I9ao7zVDr95jL7UVy8DjJshIBNuYKnt3K3V7mRdy0RrII+CDBpkarvUQ7nyW2vSY/gC176HFPutBL+bpqzUzfTxXyf05LeReEMNYtf0YLLKAWQs72OQcK/fjYW8g/5QZPwHdH/O5GOOtGPHJSTcAOHSGRaOWpVf9ypgjOIY1syvLXggiMW0vr2o2Dce1lhRnzEDDHJfwEmxrwaij27TlS96rjAoJDHfALFckCiweCuY6YHK7xYDn3bdnpDt41Wcv5zuvdi8XIpE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd folios are currently marked unmovable, so the kernel cannot
perform NUMA-balancing, memory compaction, etc. This is unavoidable for
confidential VMs (SEV-SNP, TDX), since memory is encrypted and copying it
needs firmware assistance. However, for non-confidential VMs (like
Firecracker), we can migrate the folios.

This series enables folio migration for non-confidential guest_memfd and
also lays the groundwork for migrating confidential guest_memfd later.
Once firmware-assisted copying support is available, those VMs can be
made movable, the confidential folio content can be copied separately,
and the destination folio marked with FOLIO_CONTENT_COPIED so
__migrate_folio() skips the host-side folio_mc_copy().

Testing
-------
Host: 7.1-rc7 + this, 2 NUMA nodes

- KVM selftest: allocate folios on node 0, migrate them to node 1 and
  back and verify resulting NUMA node and the folio contents at each
  step.

- Firecracker [1]: booted a microVM backed by guest_memfd. While the
  guest was running, forced host-side migration of its folios via
  migratepages(8) and explicit move_pages(2) of guest_memfd
  pages. Verify with /proc/firecracker_pid/numa_maps.

[1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
    and change builder.rs to remove GUEST_MEMFD_FLAG_NO_DIRECT_MAP from
    vm.create_guest_memfd()

Best regards,
Shivank

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Shivank Garg (3):
      mm: split AS_UNMOVABLE back out of AS_INACCESSIBLE
      KVM: guest_memfd: support folio migration for non-confidential VMs
      KVM: selftests: exercise guest_memfd folio migration

 include/linux/pagemap.h                        | 24 ++++++--
 mm/compaction.c                                | 12 ++--
 mm/migrate.c                                   |  2 +-
 tools/testing/selftests/kvm/guest_memfd_test.c | 77 ++++++++++++++++++++++++++
 virt/kvm/guest_memfd.c                         | 49 ++++++++++++++--
 5 files changed, 149 insertions(+), 15 deletions(-)
---
base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
change-id: 20260611-shivank-gmem-migrate-8c1c519b30a6

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


