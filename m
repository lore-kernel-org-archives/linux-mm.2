Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15CE4C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2AA6B008A; Wed,  5 Aug 2026 02:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9CC6B0092; Wed,  5 Aug 2026 02:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1AF6B0093; Wed,  5 Aug 2026 02:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8D196B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:41:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E9F7A18B0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:41:48 +0000 (UTC)
X-FDA: 85066270296.18.0BF8DB1
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012040.outbound.protection.outlook.com [40.107.209.40])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2FF1E40002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:41:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XBJtJGrJ;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.40 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785912105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afmFsNL6j/iJ9E32U8KDSQqP+r9OaJx+DK/3TeLQDQk=;
	b=uOQiTpD3Kw0/THNKMMRa6tlwwTkKyKcbP2cSPclJgjJ9F2mGNGaUTCgwaPegCISmz8DP2H
	7cn0BayhC0l39o0vIZ7UNFJwHasM+ndcB+zuHgKxZhHi3c/X7s5332bzTO9zAQ4oOQYNTx
	LGoUNQybqVDvizh0cQWr1K7UZ91gBL8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785912105;
	b=xrJZ8t7n6A5NuqSVVxauhw514kK28TxUnvB3Hh0lbCuWP97Y1sivvhxE56sWCHtCSaXkm1
	gw3KGF4Oz9qwNSk84ABLiLJMSy+EPXtbBW/rwqute4SfAmbKqNNNOsHANp26uW2WvUW/0s
	YI0sn4Ucj7wAYmVbrkjVMv/b95JCrx4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XBJtJGrJ;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.40 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XiWD5Ajtly82Hr/uavrYMdg7ZIeAoumDf1P19cDCLpJ8mcsLh3ITvt5Bh+uJvedFcwY50bV1bK/BRsDPrk3Mib40RLRs1dwQ2xofgybA0W0zJE0Wojg2wh5DU2sA7796mmL1bbkkTW3SYLk1xORFd+NSXIQlnBwK4h+qXf5RrLMA40haByAN5AEIr45qWjfjFXE26XO+3GWGcb3zuGxqzHo3T06EIPaCUSA2IBtyLOR8824LTo+M1OekPgL676bjtVbjpwTZ9xVrGG1DVnuEuvFUcMGAiHSEzJSnFly5JE5ioKzrHJ2WE1cezCJ/x9Joz62HckRTVmud0c8Aj7IavA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=afmFsNL6j/iJ9E32U8KDSQqP+r9OaJx+DK/3TeLQDQk=;
 b=U1+t3ZkRmFmZ/YRdCwlnELAekk7LMAzIayWAIHpJ9OyNp/YatjSh22gZBSk2Lv2lE3SfmaaSmlf39prXz1/GNgJKRNa7qo+W87M1BaMBLLLvypErHdddijvrufhdDNzqVaar/ihdHdzBZTQiO7xaudUBUl86ddR+CKRdNhAu7mcv0YHabGRDHXZZfSpqM9BMAskucnRbQxJD1ivFp2Mwyy3UKSXFivwtA34yLghuauJ0wkTQ9zETGWaU19R19RxmpoM5/sgYrUxvWUIM0FzEAEJ7LR7NsSDWCcg92uolBJsBAYfYAE8DDfSuPoAGu4NWBwr+vDVVqwRUXsLbFJCI+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afmFsNL6j/iJ9E32U8KDSQqP+r9OaJx+DK/3TeLQDQk=;
 b=XBJtJGrJmA7TImRXCnBhbmvxpwNJ+dkBNirANMafIN4deCvdTSIkgJfYZUJmvnaCbrKWIBAsqvpEVlnxBitKwG4KmWnjb0Vv6CusrkHL3JljBbV4N0jR77rviyDWbH6HQ1e3vy9/zg5NONtbCemC4L2JlL54SB32nq86ld54cDY=
Received: from SJ0PR13CA0108.namprd13.prod.outlook.com (2603:10b6:a03:2c5::23)
 by DS7PR12MB5744.namprd12.prod.outlook.com (2603:10b6:8:73::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Wed, 5 Aug
 2026 06:41:36 +0000
Received: from MWH0EPF000C6189.namprd02.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::51) by SJ0PR13CA0108.outlook.office365.com
 (2603:10b6:a03:2c5::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.5 via Frontend Transport; Wed, 5
 Aug 2026 06:41:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6189.mail.protection.outlook.com (10.167.249.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Wed, 5 Aug 2026 06:41:35 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 5 Aug
 2026 01:41:11 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 5 Aug 2026 06:40:30 +0000
Subject: [PATCH v3 1/9] KVM: guest_memfd: take the invalidate lock when
 unbinding a dying file
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260805-shivank-gmem-migrate-v3-1-00d8bdec4e1d@amd.com>
References: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
In-Reply-To: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
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
	<chao.p.peng@linux.intel.com>, Nikunj A Dadhania <nikunj@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>, "Ackerley
 Tng" <ackerleytng@google.com>, Sean Christopherson <seanjc@google.com>,
	"Vishal Annapurve" <vannapurve@google.com>, Nikita Kalyazin
	<nikita.kalyazin@linux.dev>, Patrick Roy <patrick.roy@linux.dev>, "Pratik
 Sampat" <prsampat@amd.com>, Ashish Kalra <Ashish.Kalra@amd.com>, "Thomas
 Gleixner" <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Peter Shier <pshier@google.com>, "Jim
 Mattson" <jmattson@google.com>, Ricardo Koller <ricarkol@google.com>, "Ira
 Weiny" <iweiny@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>
CC: <linux-fsdevel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-doc@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785912059; l=3935;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=Hx9UYtC7m81cRsUZoyk/6NCu3lSkUrBZZZ2qPIwWefg=;
 b=Fk56lSaOnFisB+qDkjH/DtKWve4VGfa7qvMwXYHElvxiK+c3yEFe/lnluiAQ3BI/O9OE4xshE
 BylNPbHkQvdDYvJyQFLjP7CrBuVu71gnlAYfPfBdXEvUbBu8oCF9NGb
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6189:EE_|DS7PR12MB5744:EE_
X-MS-Office365-Filtering-Correlation-Id: 949bbe7b-f0ba-466b-244f-08def2bc9879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|1800799024|7416014|23010399003|56012099006|5023799004|11063799006|22082099003|18002099003|10067099003|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	nmfj/Q49n/RA129QdZ0p6Cw+/HaDkw5UX+sRq++B6MkZQIln/09vEy9TJ+juY2rgZUZb5O1F8eigwEb9cZyAzRmVs0mN3DzgIaP5pZ7Bf5OhCVgrerx9TkMC3698tx8k81w9gyShEpRR3YN0u2y86qQfoUSRVmURckVTlfs1w9RY1rnZmRmTWAcyI54TrZ7xrSgRYMVPNWl81+kgq/HDzZLbc+XrddRgevJRCY1kZS/fzsS38GXrcVfThl2uW5Snsr+PJvzgOYEN011n+CPVpdjigosiPGfdCedGnPAkejDWC2SI7GYLc1qKYcXYSkYeT0dm63jpp5GfVlVg157Xqex/zTAG983EpvywfmGr+1ODuVmbntFbHYoUXoV6NZ/zp8Piazou8fkeJThBGShUOJpp5OU+NZxADYpO1P1LirzKZNtMUALfs1f530DjSBEUw6/nVL3ibpdf6nX9r2LJL7dtBXhwXIhhMyMVhWoZfV2H7RixLoWiE8Yf3QosJeLP9mMT7/9lBe18lAFMGVRD9w+m/JCOMIyMQowGgKdIXBeGeyx5R2gpJsfzz3PcNuo54XDYpdxd4cV2BTZi56NCsTxzAtBJWPdo8lDHqYv3g70ZuS3hfnlNLjUXnmfgFz1cWihNmWRbUQxq67rbzW4Sd50+3064snshaH18a9u0fxUfzPhrCn/O/3WlEsG8p2LXP7idcKR360h7o39Nu39AKg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(1800799024)(7416014)(23010399003)(56012099006)(5023799004)(11063799006)(22082099003)(18002099003)(10067099003)(13003099007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	datV/Epw51BdEE8tvFA3DYlsVLX1Hsu/dYeilTst+ZuO6wTU6ugGH/lvMp5Qd8ddWVf1i6Xtf3ac0CdJ+ARRrMKm50o3J/t5e0KL2QcvoJ47j5fA1mvM9wMvdE1gG6wINEXyYtVScBposg095kIjtP/kavd+ugfDKdnPEach7Qb6pCr6ITgot78eCUaK/aQhfJsxq+73C+qMeEv8dt9eHpA1+9L97OTZI/glAQ5oCYE7B82Sk3pikeM+KDFGnMQqLPYhziUf6dJarTyyfpbzUS+398QMCm7CdMnFvnPTGdkhAksR0kkwDS7bsRQyDYUhHxeLpuIi09EFvK2lo027WA60uccmxJvtE22SfJD48M5mMxaQjB1IMFU/uNF7gnvKzHjebxymjve1zIUWIfYkfMA36tUlSmJWxJw4JGlzvpAEpUTwlDX3rMf3+uFSINn7
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 06:41:35.7700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 949bbe7b-f0ba-466b-244f-08def2bc9879
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6189.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5744
X-Rspamd-Queue-Id: 2FF1E40002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: zaskggeekztktx3q1m5k8tmtu933n4ro
X-HE-Tag: 1785912105-996739
X-HE-Meta: U2FsdGVkX1+ClVR8Aa8xn2V0+lwWem2/8E8eFXmoPMawqzbTe3p3UFTIs1jrTSyavd/a6lcIZQYKetuQsj9j+UiHyBWA5L1D/GezB4PNVnV2Z7ZZEQrlG1OWT+jzUl4Iqk4SIwfEl1W9kQgSD4dX0n0EzwTfe3RtP+k14bm+Z7q1Q4odrpJG8WjZ9HGZNjaVja3zbo9nntkfPA4H8sekqVUdxq4YHdF7oKrPbX1SO2ZqOlKh1+jVgNlBJJHuEMsL28+HP5M+/6RomZekSe1TbXFuNqggjUklhEqy8XSMhQ5UQuPPqu4oyvKUNXA0LxI9wThtNy5cIsNFEkfc8/LyAJvqMeYFtphkaDcWFtzLXmeg8DdcBJuDWALKZKEWWJpAg99ukcribdiv+VwYXJ1W6Ow0mEzK1LbxC5hJKUufs9tGQFYHSmlCiQmRDmrlFauxotpjZrSUtZfgZ4v1L+CLIgIrjW1nXDQrWBOcQ2JIswF8GK667myj+/u+0biySu//oQ+YOOh5jX2Ko7eXT8bb5ie2b8OY9DW+uErufPclx5Yybf/P62/CPFncLgs2fd+t3fa3CAXF4GkmztX0sPUS9FU2MVsD7l/Sz/dEhLiw/1m5PE6CtQaHHEqaHvyb6+tHaKfQuREzSYkdvSjIYD/mFuTFs91elbjAEHvw+JnSZ1otcvNqSA8g07tRbYGZFxx20IQNza/sAQ381RnQ469Aev9+CfrWOPBuxrqmti24oL6AVol85Qjy0iIQsvyUBe3CVszrpHo9/Cf84swioe9CBJo3SV//gtZvknz3uh1gMJm0cQdeY0oAM1Hnaq6AU0Ucydel0Z+jUnsqcCA96PW7bq7/SgM0RcILoZXLY1ETiqrtpa8ARznq/0oF3fVwcanutzimJrZgVPXlA2ZgeR+e1yrAXUq0oyG0PjayPxyNyXIGZVUib07be2we9+TZkwFmMLHNhQud9/XXjOYiWys
 H1ihudXz
 WPTtRBCYhkvxUUSG4+o3oTIpmpHhAf/eZgzTAKO1vyHsEp7AsSBcYz/cVQr6zJcQNzZ1iiR9/b+fyFBF+gBHnVpTRchOmrTF7im/KycZTXmstY/hOT3XUv8ouHCim43+Q5h/MTPuy6cfb8rHrEULdEh8+fN1R23w7ta6yjyZ+Ok9+moHqxJQLP/fqWMe8j1L82xbItArYWioT3RXKwT2oV3USrtHxi0D19svVUvGo3WHjSLwlAY5XfWZ8xF8KU9sJeZREmYxEi2uGZY0PyYyiWznheXFXTy11/sch0Xrcp5DJTKsj3HLg1VYgZYVIOCrEASOlGvDGVqNOW8CgJlOCX57qaKzntFTNhm3N3A8VsPyyhI9Oisi5bDbb0S4wSL6vP/0H/Ic3TDFciuFoH62qGc5bbd6uW4/GVRAYlgystd3odeMZJTGUePSfRufxUaljLg3/4vbeDDRlzR1kM32XYLvLtMUpEvmbimnc6gA7iJaBCdpQqTJyBYt/oBMEdNxESfOEfHVPszaF0m+lYai07RwUdYJ/co7gQgIw+IKaoU1AcGkqxY32OfbGV1CUdaqmNxgCZuylYsLwhvwYNMA/mzDYXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kvm_gmem_unbind() skips mapping->invalidate_lock when the guest_memfd
file is already dying. All other paths that modify f->bindings hold
that lock.

kvm_gmem_invalidate_{start,end}() checks f->bindings independently to
decide whether to begin or end KVM MMU invalidations. So, the bindings
must remain stable between the two calls. If a binding is removed in that
window, start increments mmu_invalidate_in_progress but end does not
decrement it. Example, unbind race with memory failure:

  CPU 0: memory failure               CPU 1: memslot delete
  ----------------------------------  ---------------------------
                                      (guest_memfd file is dying)
  kvm_gmem_error_folio()
    kvm_gmem_invalidate_start()
      finds binding
      mmu_invalidate_in_progress++
                                      kvm_gmem_unbind()
                                        get_file_active() fails
                                        store NULL in bindings
    kvm_gmem_invalidate_end()
      no binding found
      counter stays elevated

mmu_invalidate_retry() then returns 1 forever, so guest page faults
retry without ever installing a mapping and the guest hangs.

Take the invalidate lock in the dying-file path too. This prevents unbind
from removing a binding and leaking mmu_invalidate_in_progress. This is
safe because any caller that reaches this path holds slots_lock, so
kvm_gmem_release() cannot nullify the slots->gmem.file, until
kvm_gmem_unbind() finishes.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260728092027.225CF1F000E9@smtp.kernel.org
Fixes: ae431059e75d ("KVM: guest_memfd: Remove bindings on memslot deletion when gmem is dying")
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 virt/kvm/guest_memfd.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index db57c5766ab6..45cbdf4801ec 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -721,6 +721,8 @@ static void __kvm_gmem_unbind(struct kvm_memory_slot *slot, struct gmem_file *f)
 
 void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 {
+	struct file *gmem_file;
+
 	/*
 	 * Nothing to do if the underlying file was _already_ closed, as
 	 * kvm_gmem_release() invalidates and nullifies all bindings.
@@ -733,21 +735,24 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	/*
 	 * However, if the file is _being_ closed, then the bindings need to be
 	 * removed as kvm_gmem_release() might not run until after the memslot
-	 * is freed.  Note, modifying the bindings is safe even though the file
-	 * is dying as kvm_gmem_release() nullifies slot->gmem.file under
+	 * is freed.  Note, dereferencing the dying file is safe as
+	 * kvm_gmem_release() nullifies slot->gmem.file under
 	 * slots_lock, and only puts its reference to KVM after destroying all
 	 * bindings.  I.e. reaching this point means kvm_gmem_release() hasn't
 	 * yet destroyed the bindings or freed the gmem_file, and can't do so
 	 * until the caller drops slots_lock.
 	 */
-	if (!file) {
-		__kvm_gmem_unbind(slot, slot->gmem.file->private_data);
-		return;
-	}
+	gmem_file = file ?: slot->gmem.file;
 
-	filemap_invalidate_lock(file->f_mapping);
-	__kvm_gmem_unbind(slot, file->private_data);
-	filemap_invalidate_unlock(file->f_mapping);
+	/*
+	 * Take the invalidate lock even for a dying file.  Otherwise,
+	 * kvm_gmem_invalidate_start() can find the binding and increment
+	 * mmu_invalidate_in_progress while kvm_gmem_invalidate_end() misses
+	 * the removed binding and skips decrement.
+	 */
+	filemap_invalidate_lock(gmem_file->f_mapping);
+	__kvm_gmem_unbind(slot, gmem_file->private_data);
+	filemap_invalidate_unlock(gmem_file->f_mapping);
 }
 
 /* Returns a locked folio on success.  */

-- 
2.43.0


