Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 539A7CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771D26B009E; Thu,  4 Jun 2026 16:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722B06B00A0; Thu,  4 Jun 2026 16:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9BF6B00A1; Thu,  4 Jun 2026 16:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BFE76B009E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:11:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE148A0286
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:11:58 +0000 (UTC)
X-FDA: 84843326316.14.399D3B0
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5FC8F180006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:11:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehepKg8FOSa82/M5mSznYS7OaYhO2ANopb6/U31fiZU=;
	b=5e2I+e37Azkz3LHEaE0W4kbfI+ZYRbol76EJVXYmNsF2MVgzAbXurCnI/fnSzUCouF5gpL
	tuEB4x3dE0EQjlEn2TfzYIoYizb1UbL/ecbFCkvlrgQb5cuEkBDZh0gaRPBUUe1zaUzHjL
	DqJYy5Cn7LnH0robgBsSdknhM4CQxi4=
ARC-Authentication-Results: i=3;
	imf16.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780603915;
	b=74hk7YMt8wf+x+/XqO8zAgoYsoFP8GjLDWmdhD3XbmFcr9sX5KwYT7xbdmF4iUKcKJ5GZ4
	Mu/vppS4+idpbWOAWQLEO64RX8+LyA0s/gcUvr1J0pZErgSPrXJdiGFFULcywSoT1ieLRi
	VtK2TchVT1fmyqTbeLY4rF1wjibZ1wI=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 085EF1401F1
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:11:54 +0000 (UTC)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9A5A401F3
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:11:54 +0000 (UTC)
X-FDA: 84843326148.27.CD8D4A1
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012065.outbound.protection.outlook.com [40.107.209.65])
	by imf01.hostedemail.com (Postfix) with ESMTP id 788594000C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:11:51 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780603911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehepKg8FOSa82/M5mSznYS7OaYhO2ANopb6/U31fiZU=;
	b=XCpe1lstZf4prFRy0Xy587LI7Kl/PfdzpDF80ojnNRbpbuAdMR0G2xOTB/M3uOLQ6I1eTy
	4pOA/uzMbfxSdRFdkJ6qEO1kXRhMF/6SnTaACyUVLfUYP3/jNsrtFt06wm6eaNU29j5rf+
	aus/pWKCBuRapMBZ5gzlffoM/NyauRI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=kWsDyGAW;
	spf=pass (imf01.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.209.65 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780603911;
	b=I+ha/bVZ+0iK6rpzzpKUvgyrkNutbFgj3ldo606ti007kzHSmW/rdYVslLr1qCawWgP5j7
	8UwkpzMB7gISONjzoPVKpy/0kH0ZYJKqLOqXyj/74zMgrcuOhW9mRS/ZSNE/JWflcDBUMS
	kRHZ5IuE3/sUIv7ea0n8BZApx8n9/So=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lBUXV649xWaB0jIvVDWBE9vQD8z5H2w0BAH2AlY6d+LfcNLW1eGFbj5rGvKzduGL+E+BvtMDWp3XDx+C/4WsSXup3L43Cz7tGLUMsW9OA2yORvbOr36NACw+wkJfr+Qr+ZaS4GZEKBR6l53D2US/ksiO3PZteXe2h9GOtZPTgK9wdU5TPAzaHNzzc1IUZIqyXUMD2mXi5bUAuJtYjw3dTTkCSS/bhPykMb55Oo3h3rvj+2PC3u338ls6hrbVA93JCHPiMtVX03lI8B9MEvbKwkXS7w81y+SfmJTd1/9syqs4jd5VuN2i1xzxSDn63DV/ohLpnwN22aXRnfEbs6EJ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehepKg8FOSa82/M5mSznYS7OaYhO2ANopb6/U31fiZU=;
 b=cV+cAZMuHqQf5t4dwLff+LVPIQ7ngTnKYOizpXBTS5YjscXmohLaUKJw/ruwC9KqUpiYSMj3t93J0cUPvswWWWZ70vNMOrRZsOpGTfpZiCdmJZohc4UVvncOjOIFTMEY64i7UU9cbkydBGimX0HgUjDzmOvm7mjxMgf3I4dmMNLTeJTdfTGXBVNHKObSib/5QaLF8u+B8Ldiui5y81aQxTl0dgF/BVWOKM1pu7oBFeFbO9X81gHq9ScEHnbDiAIrOI2e7t4HKkFSP/stig+tjUBNbothdprkDSlpDef/zqDnWi3ntRPm1wO5rlKpbCi7ZN7cHA9cKBA3J2EyTSXMvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehepKg8FOSa82/M5mSznYS7OaYhO2ANopb6/U31fiZU=;
 b=kWsDyGAWkrTkFh13JfWZHJLOTwSfiYfoVe1D3zaylmcIjFTED8+40h34skmlQJGl4U6BV4bikeNDaNtdG+QLjVgKnfHtrFrPMaMrS24/nW1hi5RSSCLnJH+ELS6w4b3uHsy0jRDWKKG/plPj9Yega5YeBXtiQMYASjqZ6IJ22Qc=
Received: from BLAPR03CA0152.namprd03.prod.outlook.com (2603:10b6:208:32f::16)
 by CH2PR12MB9520.namprd12.prod.outlook.com (2603:10b6:610:280::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Thu, 4 Jun 2026
 20:11:42 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::55) by BLAPR03CA0152.outlook.office365.com
 (2603:10b6:208:32f::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.8 via Frontend Transport; Thu, 4
 Jun 2026 20:11:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Thu, 4 Jun 2026 20:11:42 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 4 Jun
 2026 15:11:42 -0500
Date: Thu, 4 Jun 2026 15:11:26 -0500
From: Michael Roth <michael.roth@amd.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
CC: <ackerleytng@google.com>, <aik@amd.com>, <andrew.jones@linux.dev>,
	<binbin.wu@linux.intel.com>, <brauner@kernel.org>,
	<chao.p.peng@linux.intel.com>, <david@kernel.org>, <ira.weiny@intel.com>,
	<jmattson@google.com>, <jthoughton@google.com>, <oupton@kernel.org>,
	<pankaj.gupta@amd.com>, <qperret@google.com>, <rick.p.edgecombe@intel.com>,
	<rientjes@google.com>, <shivankg@amd.com>, <steven.price@arm.com>,
	<tabba@google.com>, <willy@infradead.org>, <wyihan@google.com>,
	<yan.y.zhao@intel.com>, <forkloop@google.com>, <pratyush@kernel.org>,
	<aneesh.kumar@kernel.org>, <liam@infradead.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, "Vishal
 Annapurve" <vannapurve@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Youngjun Park
	<youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-coco@lists.linux.dev>
Subject: Re: [PATCH v7 20/42] KVM: SEV: Make 'uaddr' parameter optional for
 KVM_SEV_SNP_LAUNCH_UPDATE
Message-ID: <4muegrza5iyyhqx6wevdlssnb6wvlc4m4wmuz5hmd3xikkftc4@3e2lpuq6tjgr>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-20-2f0fae496530@google.com>
 <9d15479e-e36b-4865-804c-7d93eb339e4e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9d15479e-e36b-4865-804c-7d93eb339e4e@arm.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|CH2PR12MB9520:EE_
X-MS-Office365-Filtering-Correlation-Id: 52262dc8-6390-4a33-6394-08dec2757e93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700016|1800799024|11063799006|4143699003|3023799007|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lu6sqxUGYqPCgvxOdefNZxByYSGMIpUqf8Y+mPwow7dxjlAfjtcdCLhRnNApa1qC8jTlA8nmGJq2TjcMm0wtDWPFe1KnAnl+q2E/Ky/8V8JW9wvdprKoj7tozXPN4T1SwAij1z71eaYR6YOgaoQXKq8KvJnh8e1JV4hYasgVRCkjDy3f3wz49dorkY8bWntGtRa9OhIu6HV4L2CEPhzeBiwDN2Q/T60dLONogbs3UiBGzvzvl5X7EhhRi5FwagcexmlFwqNG3vjuHagAb4ub8SlxONmBO91cneyZWTF7ObcnspaAza8ClZjShZz/y1JPV8PsHDSqJVAwRGC0SOtJF0+7IgKrkR33r+63Sl6yDgJuiWsU6phz8+Fixrzeqsq4GagJXowFQVeV+afxSF7xHNeyXcWhPcUnaSfvzeJpMqW5kKoFD8GcBSSwcJhcHDcOHQVS9FVRowGkGvNCaXdeLQhIRRqxTCZidP6YzIlusdqAIaFRwlXb1i+uR9nbytw6Po2H1NRZzb4xJFekQg4BRRnHPgEf95fq3+tOCqxfQF4yQfqvFdC+UGrxnw+8FeGfA3CLNbjR5po+bFOM7VB7Uy88DmKbkJ0hRTEK4cuuQLty2TedcJVbPmdUd2AiyGjPlDA/JC4TgGSEXOZdVNOCBtLR94dkBlJQcIqXUWhX9YSYd5lohp6rWhjsDhkSmaWESCNgzCjMpn2K6OPPKs80W7j8Cm5uVZlsdDhzOYzNEgc=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700016)(1800799024)(11063799006)(4143699003)(3023799007)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LLcs+4L3zs5m8BwYkucXGFxexfRwNBu1wJoeW+OP+EM/C/Cgznn9zpS50ANLu4aPLPo2dSsvZTJ8CtQPZPh1zSbDSSI+920AS24GwAdH6r8alLrnbzJ7yU5ka87BJnEmdC+HVmznBCRkJE4vnsvqr/kYY9pRr8Tk3M5yw8NnIdnW3/JiAq4vxm+f3PmDyo2nYPytCB/uzEVI1iHerIhEjPihXtwWZenU467cOXpa3LUtefwGPSWmQTn1fJkFPX+TaxdlTOe9Zns0Aj5uOtM8VpkJS8Pp501ZbNB9C5l2+8XUi8AwkU4tAD6cmJ4oDWQNV0W39zfT6JzlAGHvMrrh3oS44BagVG9p8YWrwd3QkiHZdU7dAO4Vswzeb6lLRSxMWwros8fe+7KFosaKZD57On3RvywUJsdAstZmtondCimpIwnxoWP25Q5RrQXnoXR6
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2026 20:11:42.3295
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52262dc8-6390-4a33-6394-08dec2757e93
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9520
X-HE-Meta: U2FsdGVkX1/0yl9pA3KBZEC8BgHmnGpDfmB9by+uxW5OzGwTxS6fVox66qunIox+UEtx0IammS6SNVdycxaVsYgeudR2CJKJp8LqCOdizgliC4Xqvfst0YT0Gjv05m7co+s/2aVX21VnLMNe25RmyyxM2GirKu+AV96NIt8xKPTROuKpm+XjzA7Af/Ri0+McVYpl7+BnucGFQ6pRELqT0L93hZQa7+3zklUVOW0umAlJozub1UELAQiLTc9qx/KsP3tsIu/FYa1FsVy5cuyF2crsqvdt7fngRSuDzodozaRSLvAPUf9FDZEkxkl7WqKvm5xAKWmP+hxMWcZs/InzIWlopWxMkZHlEkekKSjIGt3X3Qkr+MlCAu2wbPbBX9jy0OCzUsYFk4f/uGgIDk59ndMEcP7eWrGVPli5HbLSFZQwTnnzpyd2BjrXjAYiRVYgLIbCJAfw4yz0mU+HntbIpqmtsSUubGRy6NZTY5UPxoAkf2tdUBv3Cdx0IfxEC590sRk3odqyhUYvYvV5BIwF4tttesP9xYZxZF2/o4XMMOPja4J+FLvlAdpRxn/xOZ81VSYoJlCIqF8LMzFQdvItrkqRQRXeQXowGwwirYD96tODloHYLi51b4hQhUr3RGhH+sOykcV1eqU9J1F7do5GepM/BCjLl18XhfXPKVUdNtraq8EwE/3Q6Xe2rcB0c7d5gNks8JvQqxLEfbb/cJnofm/N33J/hxtFPy9gPnMjuOmQBysscY9hz8LlrQG3ZZZbZRxHdYniiDFVhjV7cWxmz+UkXeKl2YNIg6XAOhYzmcwCdjISgFRG6iJA57reQKxQJwrw0iAuhnj0eYIO5tKCxhD5XDHLTo2BzgnQ14qDWtU44qUNzNPJ7A3uztOWUe/k2VIlrs4T7FdawYrmRkKsPgajKCdSsCmUVL/JzSeAyIrtMmTIK0bdnsmUEzIY7HDev1e73+CTi3SeMdnHgNa
 nsltVSnC
 /+XGPSUgMlcgBC+2BVrhLZ0kAJsnUrJmaR7+c11CnnJTxe3KMDLYe+ZdaulIF2wdpQni7zA/6qW8nvrBIoLChZ1LOacEdFCUM3nNEDhCabG1no5zrgpVRViCSzugYDs/KxkTs7o5N0cI63bWYBOESSG1vaz8n7jOTL4fh64MeZNKrwTG/LveR17zagcCvJCUdgk4oT4tlEZd2ileNhWQIYkVNGj4slZWm1P2YWZprqvVNRSayk+uZFd+vWk71YGr//zLHy0dmwSQpv7suKk2My5l+hJ+8UYSkOj6mLCxhMF6Lzerh+vO99udkeylVYaFvetdbTfO0nBR2aCLzftKmCnt/2eY9zEGsRN6OxD2d5sRfBeoBNuUnNbFY++Sk+oK0fSYKU9Xsn3JCeZAw2ufjFCBCb8b8mn5aiFKW/FWi01qUYSEE6ylXwLbFxRv7hr+9qi0Jl1BLLhOZl+lUGLLGsb7FJd/i6R1uKP8PrhteovJeKghn7oYJBymwLpA19jpLI6Flbtbi4I1bG+dpWkUJCE6cF9eRRgbOYgxdM/FLogtqZ1Rs/29RnNpQ4NcPaZmls5fvGnjzl3lXjrzg8KPhet9RZQ==
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5FC8F180006
X-Stat-Signature: nc6ypaqjuu7p888ibw55i5q5wm6mngg3
X-HE-Tag-Orig: 1780603911-833340
X-Rspam-User: 
X-HE-Tag: 1780603915-410568
X-HE-Meta: U2FsdGVkX1/fvI8OWiBFxaZ2Rwq2jbpjtza8/6qGj9LnfxStYwMRq4rUWScY4d55XS+VdPiuNcC/PwXdK+5kpX3ppwMZIb6wo//VfKWH6s1m8frIFE1LmmRFo4er5M44HrTWl0ygzj/53o8H0ZRjPEHxZHndTXWo1/3Wl1JmFVhcjmfXuFD/42RJLdGa204h3UGZ5vV17scjQrVyMqMT1e2UYuXVMkTPYbN85iT7bNye4nRLT52O98bC0xh4Ct7Oo7/+TD4hYshohsN157fh2PnTWJVZI7UYC1TGaAmAb+CNi7+WmMdVVR71nR5gw6PiBuYY8KwioNBPMYEZrv/5CG6vBP2+gbXQJCYviIIXnL2ag+K+4c2ud22GvryM6cqh46/J0phXVwysxouNg+/0P6r3O1dT5YyYRx0klTFBytx7nQaeJM8m+uv/SDmmlm1st9BhdOBnwDZUGxTcSOlrg0dDuvRwr2cjN8ALOP0jSDMTitgbbIJ3vFlN3rRGO88YIvn6NLuao/P1eN8Qtar33nakz0X1JUnPNyHdpxMxorBJ/b5iQ1UNRsijWQOi6Sts+hRWK74LhaJl/P4QNohwmsuJHWbf1OJ/pDwlhk0vGAVygVDxgLd/YGgU0RIKrB5VV/5mku/z5N1CQiqLDJoNxi0WfiihgRcTP5JTI1zH1Eh1BygS4P/AfIL88mTo/hzxd+TDOlQOY62JU8UPwqtvEvjgZnhvsTwf17UrXF6zCycHYCddH72Doo0O/bDQC8p+8YRZtKs3CAlWUqpR+VF7d3Ss3s2emIAYIefdKjiWrv1Quu2tyNucMQQnTfGusgvlSkdBHCunJ5AXis7xKkFtFEg2uIRmn7uYpUzaFeNv0tc1L6+A5aCyz/fL7hqgEM6Xbs+xXdMOdstpm6Ku+v7tKJuDHBiFWyDE80FYnSR82dKMWDcWl1en+eJ+VcoMfktmqLnrYvJf+LDGkQmsOC+
 /bsSMyd/
 o3Sz3WHomLad12zfeeNbZom68gj0RESAmCLUUaMWP/jqhEz2tCgdDgTYXN+0A4IYbVahMfTUDaSdNs0LqD36qm6AHyDufRGyuCmDZZBR4U4msxp111G1gOTfcYkuc0z793bl1EcWr0jkEoBBjHDLYW3JlVlwbRSXB/ihR6hoVsB2aWqu76TB/d+Yu0KKEi2CBuHV06TE+04+6oWfTq+8nBJfazced2jqTvTFUzsOZMUoHJh4ApAIhB7DSBv37ixUs2V+Dn+NmdXhbestiDYM9vzJN/ZdvMZi0Z0aRey2QyqljFcc0KAFl78D/LnY3HR+878Opg23iihNtEuX6VV5UZtvIGJ340BbElLpvQiVroIZmy2QbJGnsZ4uHSbEuT7zxuRuPK4J36+JLPmOedVe4E6PUrJanUl1DAePVhGFJE7D7+n3XzA7VoNT01kZG3rVF+C/djaVvf5m8SPOfIRCtNVqtNxjccv+Iwx4x0HLH/w967hbx11qKVjJivz07VeHgWxEFY8papWIvj0Gc85PV/ao6SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 04:29:19PM +0100, Suzuki K Poulose wrote:
> On 23/05/2026 01:18, Ackerley Tng via B4 Relay wrote:
> > From: Michael Roth <michael.roth@amd.com>
> > 
> > For vm_memory_attributes=1, in-place conversion/population is not
> > supported, so the initial contents necessarily must need to come
> > from a separate src address, which is enforced by the current
> > implementation. However, for vm_memory_attributes=0, it is possible for
> > guest memory to be initialized directly from userspace by mmap()'ing the
> > guest_memfd and writing to it while the corresponding GPA ranges are in
> > a 'shared' state before converting them to the 'private' state expected
> > by KVM_SEV_SNP_LAUNCH_UPDATE.
> > 
> > Update the handling/documentation for KVM_SEV_SNP_LAUNCH_UPDATE to allow
> > for 'uaddr' to be set to NULL when vm_memory_attributes=0, which
> > SNP_LAUNCH_UPDATE will then use to determine when it should/shouldn't
> > copy in data from a separate memory location. Continue to enforce
> > non-NULL for the original vm_memory_attributes=1 case.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > [Added src_page check in error handling path when the firmware command fails]
> > [Dropped ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES]
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> 
> 
> 
> 
> > ---
> >   Documentation/virt/kvm/x86/amd-memory-encryption.rst | 15 +++++++++++----
> >   arch/x86/kvm/svm/sev.c                               | 18 +++++++++++++-----
> >   virt/kvm/kvm_main.c                                  |  1 +
> >   3 files changed, 25 insertions(+), 9 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > index b2395dd4769de..43085f65b2d85 100644
> > --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > @@ -503,7 +503,8 @@ secrets.
> >   It is required that the GPA ranges initialized by this command have had the
> >   KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentation
> > -for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
> > +for KVM_SET_MEMORY_ATTRIBUTES/KVM_SET_MEMORY_ATTRIBUTES2 for more details on
> > +this aspect.
> >   Upon success, this command is not guaranteed to have processed the entire
> >   range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
> > @@ -511,9 +512,15 @@ range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
> >   remaining range that has yet to be processed. The caller should continue
> >   calling this command until those fields indicate the entire range has been
> >   processed, e.g. ``len`` is 0, ``gfn_start`` is equal to the last GFN in the
> > -range plus 1, and ``uaddr`` is the last byte of the userspace-provided source
> > -buffer address plus 1. In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO,
> > -``uaddr`` will be ignored completely.
> > +range plus 1, and ``uaddr`` (if specified) is the last byte of the
> > +userspace-provided source buffer address plus 1.
> > +
> > +In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO, ``uaddr`` will be
> > +ignored completely. Otherwise, ``uaddr`` is required if
> > +kvm.vm_memory_attributes=1 and optional if kvm.vm_memory_attributes=0, since
> > +in the latter case guest memory can be initialized directly from userspace
> > +prior to converting it to private and passing the GPA range on to this
> > +interface.
> 
> Just to confirm, so the sev_gmem_prepare doesn't destroy the contents in the
> process of making it "private" ? i.e., the contents of a SNP shared
> page are preserved while transitioning to "SNP Private" (via RMP
> update).

sev_gmem_prepare() does sort of destroy contents since it finalizes the
shared->private conversion which puts the page in an unusable state
until the guest 'accepts' it as private memory and re-initializes the
contents.

But that's run-time, when the guest is doing conversions. The
documentation here is relating to initialization time when we are
setting up the initial pre-encrypted/pre-measured guest memory image,
via SNP_LAUNCH_UPDATE. That path calls into kvm_gmem_populate(), and it
is then sev_gmem_post_populate() callback that actually finalizes the
shared->private conversion. The sev_gmem_prepare() hook doesn't get used
in this flow (kvm_gmem_populate() calls __kvm_gmem_get_pfn() which skips
preparation).

-Mike

> 
> Suzuki
> 
> 
> 
> >   Parameters (in): struct  kvm_sev_snp_launch_update
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 1a361f08c7a3d..e1dbc827c2807 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2343,7 +2343,15 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >   	int level;
> >   	int ret;
> > -	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page))
> > +	/*
> > +	 * For vm_memory_attributes=1, in-place conversion/population is not
> > +	 * supported, so the initial contents necessarily need to come from a
> > +	 * separate src address. For vm_memory_attributes=0, this isn't
> > +	 * necessarily the case, since the pages may have been populated
> > +	 * directly from userspace before calling KVM_SEV_SNP_LAUNCH_UPDATE.
> > +	 */
> > +	if (vm_memory_attributes &&
> > +	    sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page)
> >   		return -EINVAL;
> >   	ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
> > @@ -2390,7 +2398,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >   	 */
> >   	if (ret && !snp_page_reclaim(kvm, pfn) &&
> >   	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
> > -	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
> > +	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM && src_page) {
> >   		void *src_vaddr = kmap_local_page(src_page);
> >   		void *dst_vaddr = kmap_local_pfn(pfn);
> > @@ -2423,8 +2431,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >   	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
> >   		return -EFAULT;
> > -	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
> > -		 params.gfn_start, params.len, params.type, params.flags);
> > +	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d src %llx\n", __func__,
> > +		 params.gfn_start, params.len, params.type, params.flags, params.uaddr);
> >   	if (!params.len || !PAGE_ALIGNED(params.len) || params.flags ||
> >   	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
> > @@ -2481,7 +2489,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >   	params.gfn_start += count;
> >   	params.len -= count * PAGE_SIZE;
> > -	if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
> > +	if (src && params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
> >   		params.uaddr += count * PAGE_SIZE;
> >   	if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index ba195bb239aaa..3bf212fd99193 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -105,6 +105,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
> >   #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> >   bool vm_memory_attributes = true;
> >   module_param(vm_memory_attributes, bool, 0444);
> > +EXPORT_SYMBOL_FOR_KVM_INTERNAL(vm_memory_attributes);
> >   #endif
> >   DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
> >   EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
> > 
> 


