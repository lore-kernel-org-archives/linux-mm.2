Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E0D2C54EFC
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 09:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00BF06B009D; Tue, 28 Jul 2026 05:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26436B009E; Tue, 28 Jul 2026 05:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18056B009F; Tue, 28 Jul 2026 05:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8DD46B009D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:07:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30D34A13E3
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:07:51 +0000 (UTC)
X-FDA: 85037607942.24.10BD7B7
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011043.outbound.protection.outlook.com [40.93.194.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id E1218C0002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:07:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=pDQn2oSR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.43 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785229668;
	b=tbqo+gaCjtHHagCvM8tBlXBK3acO0/aZ6h6/MTILVsPrX7XPg0MmLwDRuuBY3/M3nCbrOn
	FIgwzPVpsR15+/p2WpCU5QnJ3f2L2+/9+2YDJLFXRx+CRq3sIzn8Hul6Ppo4flPUv0tnhP
	/cVye2bz4IGUp6AhbARtvP1BiwiALmI=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=pDQn2oSR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.43 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785229668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbZXUDovpD5wFeivRWzIFccj7JVz9qdbtF6TmjRN8Js=;
	b=FSPOX8jiRqb5A7mQW4jn7eRm+pPdyrt/LBJy/TpW+cjoaBWCL1Tdp5baI4g4au/hyY6oc6
	CO/kNfVDj6mvqX+qDfCBo2HmVt80StH3SCz6HDop9UQJE1EepoQjxJVdanNhtMENYhdOaS
	tC9fmmLUYGN7V8LlZ4QQjZLV5LvsSKk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XFcRXyNqh3FBIWh5YTn4u5XxVJQn4rjV+PfZfNmUiISpMewf8MUiv3QOqcGNZ+hRxngPR2Vkp8lbQdFclX9ore9MTXXgj6C0P5w0OGUWvXTZ7PpmHNpiICuZh8NOZeXQRuiKx6OKMkPxP8nZbT5xO1R6F+HJby1SNa0OU07uswJVB7P+uzXbCTlugAFKu7KPMll8gAhca14DH2rPTpA+jwohBZWmosVy8GKMm6tLnesI8eAy4b3u4stFP0dMe8lSC7JZRzvvKEu3dnBY+xvuCQ7gXcFWb+xP8XDVLgArSzQTY07BHU2WFJAuum3m1Dvat47euEd/TmqrCb/xr48u+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbZXUDovpD5wFeivRWzIFccj7JVz9qdbtF6TmjRN8Js=;
 b=C+Xr2ZFQBR0P/dSl8zWss2rjTNuMUofPKUokuuVjWtdci5Htuvo9KTeTguZ91HkshQIh//4LRkJn82r2/aQj/r3WAothIGPHJ9mMC7dwc+jOwS51fGyeELPm9xJQifH8xfwAj6HyNMHRnzFdsfHbYEfwMLtav4MwaynXm9ISSMY3J23TWMMPy/BwZaf7mYlMBXAwMw9GfjbzZfMRuFnc6XsvzyIpdFwTy0vJybz+MxYKTTxs2pyR2Gvg+OJPIhX4a7MVAvNg2hOj7tx3KBpfdCojf12Qr7xSbRjztHSgV34a/eu8cCcIidy8nuXsgqLh2LZTaeJjR+d9kisRJ9+P/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.alibaba.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbZXUDovpD5wFeivRWzIFccj7JVz9qdbtF6TmjRN8Js=;
 b=pDQn2oSRblfYJgYvamkuxMzU42baBs0s+JIVLwnDB6YDVJwViQqB28SsJR6wn60bLPFctwmjgAnkA/912ua/6taODK2MkOCnZ2iqlP85m0p9hKcPi5VEo450fxa+7WMEBeincmfn24Asolbd32aWXWmZpjS4D2WCuCigQ1nkPPY=
Received: from MW4P221CA0009.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::14)
 by SJ2PR12MB8181.namprd12.prod.outlook.com (2603:10b6:a03:4f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 09:07:40 +0000
Received: from MWH0EPF000C6193.namprd02.prod.outlook.com
 (2603:10b6:303:8b:cafe::14) by MW4P221CA0009.outlook.office365.com
 (2603:10b6:303:8b::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Tue,
 28 Jul 2026 09:07:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6193.mail.protection.outlook.com (10.167.249.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 09:07:40 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 04:07:30 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 28 Jul 2026 09:05:37 +0000
Subject: [PATCH RFC v2 4/4] KVM: selftests: exercise guest_memfd folio
 migration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260728-shivank-gmem-migrate-v2-4-269ac1f84e2b@amd.com>
References: <20260728-shivank-gmem-migrate-v2-0-269ac1f84e2b@amd.com>
In-Reply-To: <20260728-shivank-gmem-migrate-v2-0-269ac1f84e2b@amd.com>
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
 Tng" <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Vishal Annapurve
	<vannapurve@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, Patrick
 Roy <patrick.roy@linux.dev>, Pratik Sampat <prsampat@amd.com>, Ashish Kalra
	<Ashish.Kalra@amd.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Ira Weiny <iweiny@kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785229610; l=4543;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=VNdI96t0KQwayuA0CeJ2whh9QjY4LVFWJDKSPaZu8RU=;
 b=Syu99l0mo7WyZLlDq/6jRactcfMfoQw5H+atF+briDh90+Ibp+4jh4WkDy0uZKk9uKLN01z+q
 3O18EzffbBqBkxTNsVs6Gcl/u6sCXrwtLN4vXHkIAInrvBWc6Z6pTgU
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6193:EE_|SJ2PR12MB8181:EE_
X-MS-Office365-Filtering-Correlation-Id: 14a2e1f3-c42f-469b-e683-08deec87ad76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700016|23010399003|1800799024|921020|6133799003|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Jzrm5BdFPKlQ53ev/00eeMGDIvDR0ipnEZrkVWwngxaZu/TKf0Vv/42AuSyvTP2zG6qI5Zargm6FUHpv9uBLdNEObON/9lxO7vMNrAjPuK8NNAYl5CvlNlvbcSJNKlLKfsIzOl6YO1tmtI2siA3FPQj7k3/sE/fkFu4NmBbEpjhs5wo1hK2RGZQ3TAynNhBNZsPMi5EAnEWLfWu7xzehYjFUPXEi9JolxNJwvUkZHXsWU7DHNZiLM9a+7ETY1svyj+J9YLgAtY/4n2kjTqdyT33kSsFOMSIZm2Gf/sJjqU0d35W+jWD9PWG23ZDVV5mB6jF85NQL6AiNJ8vJGYZyGrieNW2ovQSilKobTWtoe7j4gwG/duUPhAqGlT1Q3hyMOtkS5nEm7hnyoTytPHX++2LPjlAcUZlp+uj9ME2MlQzgXu/MGhGPUS9bzs++vo0NPqUUNYGVONubGzNeIc7jUKfixzLnS7JOSAHlI74la64C0I+sKD6kLagl3CvmGiasgWXhFlmyenCZuN+mvqHEw9WxyR1qA9+2YCPWobV8QBLDH/0TfldhliGK8W+OQELfs1IXvov5kOw2MFKEM3FT52lj/Zv5gZlND4ixbkc+v03HRiAaSAzDczcTo6hSYEwRzgMZIgFFhU1oy1TXLAAe8ASSj0vo6IG9gfHOe2KHdVBiQpUN9aMJBYQxYqJM6r+ICQ0jWtPwTWPzkbFVrsDSj1aRttBp2ZEZhMH/MpCqmJUorYnPJmR09R3vKTFNqXLv
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700016)(23010399003)(1800799024)(921020)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	USv4GbUztay1QfkhYuIBA4/9zdPG55Hw2O40rCtd6ORgB5m5In1gb2wevimqms7rc48j3WC6OCK1Nx+mZngUiYER4GJgItI3VaYfsrZxrNjaSHythadWx4MRM3oEh7fYGlRxz1i5QQetfK0wiDKDVZ9W95DTsb4J9KH6DkLSZJCpAX0JSm+7/Ntq56K2EWIQMdiMu+19hXbH2IH8srM2YN/mcaT9lTvUO+UmEe0CtATSQaQllnz83vGao5kmV7dsTPSAPjt6/I+r6JoeIlMzk1Q5qAqfOmp62qlZfrKlXxjhcujJKRRTPFcEG6Wm0L/4/tlD0gYRZsrYW/7GXPWM6ImGjqLaKHJohCRD0qP8nroAL9Kj2lLCLMZgbMAYsymBcQqgzdFYVZwrwz31a2qKGbZBJZqcWj2mBxuxmamEoiue1ArbgnooZ4y3XRMUxUR+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 09:07:40.6848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a2e1f3-c42f-469b-e683-08deec87ad76
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6193.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8181
X-Stat-Signature: yzbbo55nnokdmazqg18c1qbru9bn751y
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E1218C0002
X-Rspam-User: 
X-HE-Tag: 1785229667-512831
X-HE-Meta: U2FsdGVkX19CFhb/hWqvUopm52w88OD/wON3IUG+oUN6RTfDrssouISJRDYHFs+Duk7ETpT4a+XVcVUo9JXoiuIstlp3LTRlf+4SyznqR7GddVxnJpZOF55zX/cmIlamJ/KFa9sNjSLmXrvz3w4PCQSG0ij7f3LNWhvfALB/gfglNWJjXnjUzad+6oyFDB3ugqjG0PDOEQC+WZzQ6oeOJb7GRwG+AYUpmXFCDvmHknmBits0GP3u4cAm4i7VxVaymIpP0YutwvcnWVfqvRb0lYHIZgBvLZW3Fp+7x24q+X1D9IOPYg2sZ1MQmOWonbRCTjzTtVaqKBGX5jBD2nlL+Z2Ab1Iw9BoB9xjS8g5hpxtSsPN+kd2eqHaQpTopI+Qda5A4AipYGLp8Mwy0ZAK2qJwya45s1dextjdpDXvIapDnFlcnrznm5YLi0dws6cb/4uKWu9EVjxGiypVQCyGYEqKFlvxGfFlycHA3je585hah826zrGQXCK4QQITUp+02V5mN1KmhZsR6flw6+1ZVNSl7D4hHZV0+mLcBcsgQ7BxbdLsJurY4lYydOKOmVqbHMMphrZZ/gyI8zCdUBFAneP36fLHlHrF2JPTCCx/xV8BLefc72/TQEAKfnANibSq4t8l8qxTojirw4DXr/McjFUKNxZbxU/+gIJ4/EPPofVdTtaXwjNjtBFKcPVawE1n3fUINMAiV0nCFM1Yec2HOHdWLQ0j/fMO6ew3309c3pT8bnqFqQBqPKXlV5mbL9YmCJormYdkapxc7/z9FJgUylcwnDn+UUHAXVGiAgraJhkJj67TVmeBsme6NuMhpySvKps2SpSJoR0J9/097RUvV36D5Ue5cQ3t1xsF9v3UMjPtunz0/I5RwF7W4bAGQnizqLer3noysiIKlCYvyTq9aGsoe0iXhg6pHG39a4yfA7ToKbq4DmjlL/mQkwAwo7/hEaBceApnC5rV1nX5y1sF
 5Ctjp7nb
 CsNwZ9u8RAODTAAGpu25MXAVhrLDc98VN1JXcsFfP7Ahke8Tn81wntC384UqhqftAs8WR8p3/cJR2JHIaLIWmuRMUGJbeIZc0+G+K7cF59n1sJ2dNaqxWK8InCUGeMKvj4f8PxiPwmRF9tdOnc3IyuyQPUXFv8OMXcgBWP8OCMyssho+MAND1yM87yqv3Rrumu4gEtY9OTmBMivtSCHdJgNb8gSWu3zVGb8YW4kIHGTLoJKty+xPxrn02KdnP4jgGtEDzb4dkrr8+ScCOKX3/aDwSoapKM1vZrGlMAuN7uk1EbyNkwtUKW2RBqX2qymxN/FMgqC4fypy05O445LI44BOADMmeEmn+DRePPcgrlEv3ldBm9MtI/zrI/+Suhyhlsfx1IQgzgmnrVWHFAG5x0MOcDvT0IbMRUvsuUYd39tAHvKvIaqlusSr6HNiHSLx51+ZDWtsdTznUnycl1NLxW9uxCvULF6MaApaUc6swuUOUfYGiKgONoKDdKh0nTDeSXkzSi6LzAhNKTTzg9NRFjiwq68pSQkNt/VY9pl+d1JTpKHKp1A8W3vuONQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a migration test to guest_memfd_test using guest_memfd files created
with MMAP, INIT_SHARED, and MIGRATABLE. MMAP and INIT_SHARED are required
here because move_pages() operates on userspace mapping. Run the test
only when the VM supports all three flags and the system has at least two
NUMA nodes (skipped otherwise).

Migrate every folio from node 0 to node 1 with move_pages(), and
verify both the resulting node and contents. Migrate the folios back
and verify their contents again.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 82 ++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 2233d871a38f..77e034a9d587 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -171,6 +171,82 @@ static void test_numa_allocation(int fd, size_t total_size)
 	kvm_munmap(mem, total_size);
 }
 
+/*
+ * Each page is filled with a distinct byte (its index). Check every byte that
+ * data is intact after migration.
+ */
+static void verify_page(const char *page, int page_idx, size_t size,
+			const char *when)
+{
+	char expected = (char)(page_idx & 0xff);
+	size_t off;
+
+	for (off = 0; off < size; off++)
+		TEST_ASSERT(page[off] == expected,
+			    "Page %d corrupted at offset %zu %s", page_idx, off, when);
+}
+
+static void test_migrate_folio(int fd, size_t total_size)
+{
+	const unsigned long nodemask_0 = 1; /* nid: 0 */
+	unsigned long maxnode = BITS_PER_TYPE(nodemask_0);
+	int page_count = total_size / page_size;
+	int *status, *nodes;
+	void **addr;
+	char *mem;
+	int i;
+
+	if (!is_multi_numa_node_system())
+		return;
+
+	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
+
+	addr = calloc(page_count, sizeof(*addr));
+	status = calloc(page_count, sizeof(*status));
+	nodes = calloc(page_count, sizeof(*nodes));
+	TEST_ASSERT(addr && status && nodes, "Failed to allocate page arrays");
+
+	/* Allocate all folios on node 0 and fill each with a known pattern. */
+	kvm_mbind(mem, total_size, MPOL_BIND, &nodemask_0, maxnode, 0);
+	for (i = 0; i < page_count; i++) {
+		memset(mem + i * page_size, (char)(i & 0xff), page_size);
+		addr[i] = mem + i * page_size;
+	}
+
+	kvm_move_pages(0, page_count, addr, NULL, status, 0);
+	for (i = 0; i < page_count; i++)
+		TEST_ASSERT(status[i] == 0, "Page %d should be on node 0", i);
+
+	/* Migrate node 0 -> 1, then check both the location and the data. */
+	for (i = 0; i < page_count; i++)
+		nodes[i] = 1;
+	kvm_move_pages(0, page_count, addr, nodes, status, MPOL_MF_MOVE);
+
+	kvm_move_pages(0, page_count, addr, NULL, status, 0);
+	for (i = 0; i < page_count; i++)
+		TEST_ASSERT(status[i] == 1,
+			    "Page %d should be on node 1 after migration", i);
+	for (i = 0; i < page_count; i++)
+		verify_page(mem + i * page_size, i, page_size, "after migration");
+
+	/* Migrate back node 1 -> 0, then re-check the location and the data. */
+	for (i = 0; i < page_count; i++)
+		nodes[i] = 0;
+	kvm_move_pages(0, page_count, addr, nodes, status, MPOL_MF_MOVE);
+
+	kvm_move_pages(0, page_count, addr, NULL, status, 0);
+	for (i = 0; i < page_count; i++)
+		TEST_ASSERT(status[i] == 0,
+			    "Page %d should be on node 0 after round-trip", i);
+	for (i = 0; i < page_count; i++)
+		verify_page(mem + i * page_size, i, page_size, "after round-trip");
+
+	free(addr);
+	free(status);
+	free(nodes);
+	kvm_munmap(mem, total_size);
+}
+
 static void test_collapse(int fd, u64 flags)
 {
 	const size_t pmd_size = get_trans_hugepagesz();
@@ -472,6 +548,9 @@ static void __test_guest_memfd(struct kvm_vm *vm, u64 flags)
 static void test_guest_memfd(unsigned long vm_type)
 {
 	struct kvm_vm *vm = vm_create_barebones_type(vm_type);
+	const u64 migrate_flags = GUEST_MEMFD_FLAG_MMAP |
+				  GUEST_MEMFD_FLAG_INIT_SHARED |
+				  GUEST_MEMFD_FLAG_MIGRATABLE;
 	u64 flags;
 
 	test_guest_memfd_flags(vm);
@@ -486,6 +565,9 @@ static void test_guest_memfd(unsigned long vm_type)
 	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
 				       GUEST_MEMFD_FLAG_INIT_SHARED);
+	/* Testing with move_pages() requires MMAP and INIT_SHARED. */
+	if ((flags & migrate_flags) == migrate_flags)
+		gmem_test(migrate_folio, vm, migrate_flags);
 
 	kvm_vm_free(vm);
 }

-- 
2.43.0


