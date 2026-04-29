Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54948FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 23:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EE0E6B0088; Wed, 29 Apr 2026 19:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69EA86B008A; Wed, 29 Apr 2026 19:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 566A26B008C; Wed, 29 Apr 2026 19:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 400CB6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 19:22:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C3F1120278
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:22:25 +0000 (UTC)
X-FDA: 84713169450.10.7B0F401
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011049.outbound.protection.outlook.com [40.93.194.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id 53113140005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:22:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1WOCJc93;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.194.49 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777504942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1rJItAU+CKsV98tcrZ0BfK2zyiexu+0UrQC7zrCtbk=;
	b=mJOan9tuHVZ4+Gxk+Pl3mv8fEXtahFLu1wL9sKD9gaiPc3CfrOGoNjWPUwBqKZb3FXgAG2
	hEAViTiyn8yz750YEQIKnfDt8dxUXLE9j6F4qDSakDMd9V57sNHS2Ek7JDQwwMBz5T6Ep5
	fyg/+J/3axSJMVesY5Rdc3FW4vzdYj8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777504942; a=rsa-sha256;
	cv=pass;
	b=h+uUVexTx0lSBbcBNAdKPkx8ZuA+AYY5NoVt61ngtOccNfTPzlLHLHKKm+wsLEan+s6Yy0
	Dsz6vdfaoVrb45OKULOLC816TGPnwIF3ZhdH9IBpUXyM88vaca68lzgTtZQ1Ypy3slPKNN
	4SaJe8y+WteIJ1DahdeVObl+afd/9HM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1WOCJc93;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.194.49 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YjM5FP0LkDvOrZKevfESA+b6m3nkgZwsAmbkUQwTURoeE/14navYZIBgdgwe+deprXe9zrYA826Lw2m3fSk0/IugmsFLj6NsHaHfHFabB1WScRwaGPxo7wmvy4dd8xLDLoCtdO0dZfsLjk38fqpzGze6Cp2V+0OugRMFnQD5crPjFXKZirrWvgDczRyfC3Fn8fnBlVPC+dqDZOe77iLej24/X9TbGdNq0TyYReanvE2Y3XwGx48CqSbJW/RDDlvHWIJb9ZTzH6oMXPT2/iNKBatqDFxU/tQrkHjruebwob2dSS9yDUjFBJsBKj9zWdEp+18rwdwCwXH4ofM13U8lCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1rJItAU+CKsV98tcrZ0BfK2zyiexu+0UrQC7zrCtbk=;
 b=BlYx7LK4EMYe+6E1VfdT32jX/7/OrPf4+Q22ni8cZVLx6GxdXVZmPDpPyO+yMLuQ6Xi9P8g5+IYBqM8CYGqKJnM9GVAe16RDN2x2MSg2RFoBzQH1a7wn2oR545THkPVzUaw6WeiB18P4gAP4U7ylcWe/+T23e6PaZxy2bgmSX8+raPwu63mhJAzFRWQT9/f62s39eGA1cfAD72UgYLH2tMkBTwjTN0u3scbfEpIOVooBBcB/xqYFqUvhPKkFB/pt7LMRJo70FYNz0EUcSmXbQhQe8+Vsip6gGURHkqH0ZcP3AIT8sVzHyiYIsOktxCn+zqT1FT4RLafn6TSHtJ0Uow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1rJItAU+CKsV98tcrZ0BfK2zyiexu+0UrQC7zrCtbk=;
 b=1WOCJc93RC7Ov/h52aevy6hzLbwUIt07Psejc8PeFUFVG6sDuhkZUoKlKbEaI/KsAjc2GN+SpU/4TjxFZLXpJMTijS9skT02R4DAFSelk+WFchdjeS4d7N8bJyQJs1pQj2kCLqvCl64HlSmGRKN9GbnvG81eJ8W9TPyuggKJBTs=
Received: from DSSP221CA0008.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:3d5::14) by
 BY5PR12MB4275.namprd12.prod.outlook.com (2603:10b6:a03:20a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.18; Wed, 29 Apr
 2026 23:22:13 +0000
Received: from DS2PEPF000061C7.namprd02.prod.outlook.com
 (2603:10b6:8:3d5:cafe::be) by DSSP221CA0008.outlook.office365.com
 (2603:10b6:8:3d5::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.30 via Frontend Transport; Wed,
 29 Apr 2026 23:22:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF000061C7.mail.protection.outlook.com (10.167.23.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Wed, 29 Apr 2026 23:22:13 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Apr
 2026 18:22:03 -0500
Date: Wed, 29 Apr 2026 18:21:48 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<ira.weiny@intel.com>, <jmattson@google.com>, <jthoughton@google.com>,
	<oupton@kernel.org>, <pankaj.gupta@amd.com>, <qperret@google.com>,
	<rick.p.edgecombe@intel.com>, <rientjes@google.com>, <shivankg@amd.com>,
	<steven.price@arm.com>, <tabba@google.com>, <willy@infradead.org>,
	<wyihan@google.com>, <yan.y.zhao@intel.com>, <forkloop@google.com>,
	<pratyush@kernel.org>, <suzuki.poulose@arm.com>, <aneesh.kumar@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Jonathan Corbet
	<corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan
	<shuah@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for
 KVM_SET_MEMORY_ATTRIBUTES2
Message-ID: <foi2zvv5qrfdcspnx4fstrvzl74m6xp6zrsw5omlbprxh4jrhx@vxnwk7fr46gu>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
 <eiiecl7jvywvqb4drq7cchmcabcrdka25wxr77uavxqineeedm@rfcnhdz6xoxf>
 <3blpenhpvysb2ig7efegedx4v3flppl5ftnz6vhpqlatfk3ycn@vmmhs7mvjieg>
 <CAEvNRgGbMhkX310CkFY_M5x-zod=BDTiuznrZ0XvFPUK7weL1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgGbMhkX310CkFY_M5x-zod=BDTiuznrZ0XvFPUK7weL1A@mail.gmail.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C7:EE_|BY5PR12MB4275:EE_
X-MS-Office365-Filtering-Correlation-Id: 500d6850-0b33-4e80-aec7-08dea6462504
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|7416014|376014|13003099007|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4W3BHvPVy/Ic1HuR9ncBNyMOhaVhm4Wn44a4OsHt4hwMszhl8iiAnwekV7Hkyotdd4ckEDPrFljk5gDj3XemwVhh2n0Kw9NUQFPFGjOK6HuTVWnsn8uvH/qeOUaxqdVorr7foHCdp/0D9ytJLoOfM7D1QOFO+VJNxaABiNq45USb8jzWHl4DbLsFCyLz6Qwjc1mV/Le29jGfzfAC4QiLGj9LQqvkoE+OPmCLrURSPBGwkbj+VNIv4UDXlO/vIR/oY/46VFlrHnGv+Lmsqx0MEbRBc0BncfsvYOPYfBtSx+2qa1X9ziTHs5Gamjpofwpb/f+7EFcAR4Y+aCACc59wNF/J8M1DNgFIulOkeSir93onh09pnVHzs/k6CTFL+2UvlyRI9Ez0VxWG6/XH8Vr2RO4ZcjuqUJAATu3EQ4L9jEADt4JDKMi7tiEmeuJqmZYj2rFYJZuDa6vF+2B+iZ8ymE14GfnTp6aRS2xoS8rKdXhYHRVlFhX2moGH8wGuatqWJJH1bXuXfIQW3S3lpcpz2s6s27abLSFgoc992GNyJJ6HxnnmVwlgMiwjj9Ist93glkuybvQ1xT3MY/AT3S/ULRrsxEHs1b+VDXNQb56uF9aZelSkk1SvvgHPBy+xXByTsNi0wZ1udCcqyO1wMyW98Wng3YsMaD+QmvgfmzRziayKoOLHJxjl/TE3s+b/U54/sZfaDpdmQBCj3f/lqjUyuE9dQXkD4V9pFyY6MaMTl/tbj/4StWKsbUkjD2ESawIe+dROogRrk9oizWpyMWwh/A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(7416014)(376014)(13003099007)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ggrMGTzSnPB829yb41d8c0xYIndsy10JUzvPV6QoRSM/L2fcN5nIQh73F35DTrHm1f9Q0+IN6YIyHJvV2CgnrMtf4tAo3WKjqWqviokKq+nuKgsGv4Hmqgn8Gruw+Mia1cl0YbD92ydSVz+mQWa0kBC98ZGb9mrkguOrZvU88LqxkZiAGoKIuJgzdnPfbsCBRydYeRLqgJuDb64mxR0czU0yoOd6JLpRWtIFcCgNUWpK71uFZUyNtCz+UAMPNn1Z+8Eug4ssjY1ilbc6WWaNYTYyNdPmCPRLtvJ0Rkwoty71UKsNuH/wZiim9Y/29UHRsGzg6qB/6o5mIkcH3n9MNaYGAHz3YA4qsIXGnOwLtfgdIS/ghGuhlH27FLJRzmiaXYDLfykFBGyfUtju1K5078TqlR9u85RCi0BkRhjN8cbhYDn3+ghifBt2SOp7+XLV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 23:22:13.1377
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 500d6850-0b33-4e80-aec7-08dea6462504
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4275
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 53113140005
X-Stat-Signature: mcyhxg7ttcbehrxaogttxepxwd9q14px
X-Rspam-User: 
X-HE-Tag: 1777504942-140084
X-HE-Meta: U2FsdGVkX19X0RzJJC88PekLNKsiBNmGCL3s3F/gks2fBi5AycB32na52lksljzap6B5YeYA2o3Z8SMN6Yw/p70Ewl/m/HYhN4Wa5YerMj1lj9MmR7P2oIYctM7jdhMqPePodgEQzbYosnlXw685L1tGN29/xYEHTKnBykcM+yPewcBDDTV0MHeWuSIRGLUX9HTtz4R7M1gVJFqJSmC772iw+LxCXoukCyVCHYOuJIPv5tG6C63GBGGSjGvzBufCN6nhflpK26GFBRzfAiCOtBAdjEUQ5JxzXjl2roC5YK7G946p61l/gtxLiVpBqDF+qMqgA7bvT6ym1wX6cvu8Cy8W+C5pRiWLlwaITXHdqapoH2WfCQwuitVpZK3qRJzuTdPQE7F19jap+en5F32vrCOyGwFZbhdY5RAwhxSovrFL9cGywm6NRWv5d+WkysfgPmFikb83AdFzF9EAFD743Krd3xZUBxxSR7izYerYtXyr4moVuiIseygfoVIMK7INHcvzKaS7H6i3n9vaqVh1D+Sz3G4dS1WnG/ubizphiIwxrxd1LSi2eNdaCOo85ALh5rGh5MkzbkjQCFGdpILEzmsg4D+3akrmBl6FrkbKvKMJu2q+rFZzWjQ2zDDq5QPujoMtXDeAPBm2OUFnE9F5YWp/gDs4VN3SZBJP84AbBop4fZG86vCjwSx0JOtQIjIY0ZUL6Oj1Nv1lyt86JBN0oZ39tDXtVchvGKkSPfjtPcdv1Oqu86UPZ6DJhOWu373e7Q+lpnEIo9dhY/XmqqRyVoOcxyCpHmIjqKR7D3H5ICmQBdnrp9GH4GytdUI/QGObeG9ybok7LAmFK/cjRfT6TQf7efK2dZR3PzcH4ScprM543Kz7YRlaYo3zXJrbP68lu/d8SkWOsbSL3ff4p/Mda+N+KujNrY2NUH/KkHq5MCavQ+85ZQVhWfZfKvOkjfmwgqVdmIIO1A9yuDbXkRl
 mnYvyH1f
 E1kelVwSKB/uXow/BFp512LdUDa0vdrjFs2EMX7IxiCNUEPryTwDbTm+nR2l9MOS0RhzxR/w6tfD6+l3pSSyn+H34B5R9wtTT9VnF3/uTNX/9wWnWkN21lzdjYngTZaL+7biJIAG1numt/56VtwNuvZ8w2j+CzKWhrCuq4kgbvXwx4IK/vk7KthY/DPZnZuPfod8yVyam1mpxMJWAfui2Eg9krh3XeIsrRKFbl/fTTQ9zonViGALjD0TQyaPDqoD7+63BGXahWf1YmC1d52aIdvB/EfWpVWtUTmDLH7w+Yx8EQMrbGKZy7pl7qoBvvLTNP0ogHXrREpxsX9HhpGkq2fb8T9i2hJIRveC6veJGLQ8uDWhE/tkRNgpMNrrNkMsFbbdORM0U5dYZ873DIOSc2zDjDQagrPRs6xieyemhrJblG+lbRj1Rvt5yF8IWC8i/DvEVnknGDDlP8TVrKPCuqkA7O+B3zew4cH5aFYIqRsuEnvuJLkNsNGEU6RkqNKAkdyQPh9UNFX5v0ocpcdsxqCKdVEKqnke4ETBK5F4GV1IAApZESLcuIxpbHxCoscgnFBvfI+52760KW00Td9Tt1fMWL1fZY2VuMjna6BxTDaFmFG7CWEQVPe0ISw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 12:08:45PM -0700, Ackerley Tng wrote:
> Michael Roth <michael.roth@amd.com> writes:
> 
> Thank you for your patches!
> 
> >
> > [...snip...]
> >
> >>
> >> I also did some minor updates (prefixed with a "[squash]" tag) to advertise
> >> the KVM_SET_MEMORY_ATTRIBUTES2_PRESERVED flag so it can be used by
> >
> > Though I'm not sure how we deal with it if SNP/TDX at some point become
> > capable of using the PRESERVED flag *after* populate... but maybe that's
> > too unlikely to worry about? If we wanted to address it though, we could
> > have both PRESERVED and PRESERVED_BEFORE_LAUNCH so they can be
> > enumerated separately from the start.
> >
> 
> Not sure how likely it is, but if SNP and TDX can honor PRESERVE
> semantics after populate, I think we could implement support under a new
> flag like CIPHER.

That works, but it still makes things *slightly* awkward due to special-casing
the PRESERVE semantics for 1 guest type vs. another.

For instance, for the QEMU patches what I'd like to do is be able to
issue conversions with the PRESERVE flag set, and it makes sense that
when the function that handles that gets called (in this case,
guest_memfd_set_memory_attributes_fd()), it asserts that QEMU
checked for the corresponding capability/flag (via
KVM_CAP_MEMORY_ATTRIBUTES2_FLAGS) earlier on during QEMU init time
and stored that into kvm_supported_memory_attributes2_flag to check
against later in cases where we try to use PRESERVE:

  https://github.com/AMDESE/qemu/blob/1308d4bcd8dd8acd151243e96ff0be4098389b93/accel/kvm/kvm-all.c#L1655

but that check is sort of incomplete: for use-cases like pKVM it makes
sense to allow conversion+PRESERVE at all times, but for SNP/TDX we'd
ideally have an additional check like:

  static int guest_memfd_set_memory_attributes_fd(..., attrs, flags)
  {
      struct kvm_memory_attributes2 attrs;
      ...

      assert(kvm_supported_memory_attributes & attrs);
      assert(kvm_supported_memory_attributes2_flags & flags);

      /* SNP and TDX only support PRESERVE prior to launch) */
      if (vm_type_is_snp_or_tdx() && (flags & PRESERVE))
          assert(vcpus_not_yet_started_and_LAUNCH_FINISH_etc_not_yet_called);
  
      ...
  }

maybe that's fine, but there's just some asymmetry in the fact that
the capabilities checks are essentially self-documenting/self-enforcing
in this regard, except for PRESERVE+SNP/TDX where userspace needs to
sprinkle some additional vm_type-specific logic.

So that's why I was sort of thinking PRESERVE might deserve a
PRESERVE_BEFORE_LAUNCH or something so the kernel can enumerate the
support rather than userspace needing to read into the documentation /
implementation to implement finer-grained checks/etc.

> 
> CIPHER can then be used to mean "do the encryption or decryption", and
> for platforms not supporting encryption, they'd stick with PRESERVE?

It's all theoretical, but I'd imagine that *if* SNP/TDX ever added
support for allowing userspace to write encrypted memory into a guest
range, it would be something like:

  - write plain-text data to corresponding GPA
  - issue shared-to-private conversion with CIPHER (or PRESERVE) bit
    set, which will then be augmented to make some sort of firmware
    call to encrypt the memory with guest key and make it visible to
    guest

So, at a high-level, if host writes 0xbeef to shared memory, then upon
completion of the converison ioctl, 0xbeef then be visible to the guest
via encrypted/private memory, which seems to match the semantics of
PRESERVE perfectly:

+``KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE``
+
+  On conversion, KVM guarantees memory contents will be preserved with
+  respect to the last written unencrypted value.  As a concrete
+  example, if the host writes ``0xbeef`` to shared memory and converts 
+  the memory to private, the guest will also read ``0xbeef``, even if
+  the in-memory data is encrypted as part of the conversion.  And vice
+  versa, if the guest writes ``0xbeef`` to private memory and then
+  converts the memory to shared, the host (and guest) will read
+  ``0xbeef`` (if the memory is accessible).

So it seems like a waste to have to add a CIPHER that would essentially
have the same semantics (even though the architectural implementation
details are different), and then complicate the documentation of
PRESERVE to have vm-specific behaviors that userspace needs to account
for, rather than leaving PRESERVE as-is and adding a
PRESERVE_BEFORE_LAUNCH that neatly encapsulates the specialness of the
SNP/TDX flow without complicating the more generally-defined flags like
PRESERVE that could in theory become usable by all variants in the future.

But then that sort of has me wondering if PRESERVE should be
PRESERVE_AFTER_LAUNCH (to cover cases where maybe SNP/TDX gain this
ability in the future, but can only use it post-launch, where other
architectures might allow it both before/after.)

...but that seems to be getting into a more general issue of how we
determine what is available before-launch/after-launch, so maybe instead
of introducing new flags, we just have 2 capabilities that returns what
flags are available at each particular phase, e.g.

  KVM_CAP_MEMORY_ATTRIBUTES2_PRE_LAUNCH_FLAGS
  KVM_CAP_MEMORY_ATTRIBUTES2_POST_LAUNCH_FLAGS

And then userspace can easily probe/lock down what it expects to be
available prior to launching the guest vs after without any vm-specific
logic, and we can continue to just stick with PRESERVE/ZERO. (and if
we do end up need to further distinguish pre vs. post-launch behavior,
this gives us some flexibility to handle that as well).

> 
> Should we redefine the semantics of PRESERVE to be "ensure that memory
> contents don't change while guest_memfd tracking is being updated" and
> avoid making a commitment on how the guest should read the memory?
> 
> The above update would be aligned with ZERO not being allowed for
> conversions to private (because KVM/guest_memfd does not make guarantees
> about the contract between the host and guest.

It's a little awkward here too, because PRESERVE is sort of making a
contract between host/guest: we are providing trusted data to the guest.
However, there's an attestation proces that allows the guest to enforce
that for pre-launch and ensure we are following through on that
contract. PRESERVE for post-launch...I'm not sure how that could be
enforced, but I think this is further reason to allow pre vs. post
launch flags to be enumerated separately.

Thanks,

Mike

> 
> This way, all of those (ZERO, PRESERVE) will focus on KVM's interface
> with the host.
> 
> This lines up for SW_PROTECTED_VMs too, since reading memory that didn't
> change in the guest is the contract between SW_PROTECTED_VMs and the
> host.
> 
> >> userspace for SNP/TDX in the kvm_gmem_populate() path as agreed upon
> >> during PUCK.
> >>
> >>
> >> [...snip...]
> >>

