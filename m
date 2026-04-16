Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2473F433D9
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 03:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B96C6B0005; Wed, 15 Apr 2026 23:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243246B0089; Wed, 15 Apr 2026 23:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4786B008A; Wed, 15 Apr 2026 23:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC6B56B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:06:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55CA51B877B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:06:18 +0000 (UTC)
X-FDA: 84662930436.29.EDFC7E5
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013026.outbound.protection.outlook.com [40.93.201.26])
	by imf29.hostedemail.com (Postfix) with ESMTP id 327D612000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:06:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=S4DS8fx8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.201.26 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776308775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfB1la0BQ+f5QF5Nfi4aoLs9hdI3G61W/EKVxvz+7YY=;
	b=wmK44gifFlc2msLmcMRmC/+lZO48OqO6Kr1HL5YH2HTpG4OxWIkVdS0pbmosurnweza+MV
	pmLIB2IcC2Wa5tek8fbwrKup8/tqA5jiCcbuFdI0b5H+mlQcJqQOD9m2tevWoE+j0Lgk6T
	M6J00+h8kfuxZwbHFwmuzxYteeb6VkI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776308775; a=rsa-sha256;
	cv=pass;
	b=0cBH7MOIkW5Jq/eAXhTl5sTQMpZVUbijfS+F9NRMJCDdwReWHl+wg9rgMSWG5/Ii0SKrpx
	nAMy40d03x/lngwL20edDPQ4Ba+z3c1vucpD67hb/JpwZJsNOlDG2ly05mZvW/GNtowcYz
	JmbI2q/giUG8DAuoMoSxewZstr3KvG8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=S4DS8fx8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.201.26 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VmljPDRBunZfQEMv7paxzmJJ0rnVD1e+1tp4TM5o8TEidSUOmExzBnDbToKejHflH1AxyzSmhz5h1t/W+WXzf93q0TNx/GshKaMxhPsySKOu+gMTqAgao95xnCZ3LLrLDcBxmVHMGsqvls2xNpGieL86SI3fzxagxsdRopRRDq/ZIgWC0DVxrlXvFWFSgufS1ADA6qvyPzoe8KkBL2Ss+pagUkWunlGTLRltWTrqnOOfkjsgGuyXrkfx2KzDfWMLnU9CpXoT6DhfDWoNoJIuJP9IBFJ4vzaiz+Wb2DNKPFDczwfELGcAPk7zTNekU20OeWkQ1rR5EP/ITFq+mEx9NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SfB1la0BQ+f5QF5Nfi4aoLs9hdI3G61W/EKVxvz+7YY=;
 b=AL3K3d0fK8A0WmMlK9IJRt8kYS+NjmKM1nCPUnTYN8rLbQrphxxyRLcx9Vdr4MpdKoVTaXSMc8wu8KgQz6breteZTMcn5wNKaLu+Pnwp5Qv59JgiHZB5u8SGzQW/Ca/4ON1K0r/FGRMM4yXbYRTb3nJWcSh6oxkLlctuvmT1OX2PSkXsHXC8rGc3sVuxWfLbKRsGeHWCvuPVuFZ1UiLbd8p8RTb7Fz6VMJtj9orDYk8wWShhznnchDXkDlGbxbl+YZKoDFxfTnO0efJ+9GqBUf50sT6pK5vCKmFN+ByJHaTf6nMEDF4X6SVoRiJmjZ/t400uOp3851p7jnpiGMP/5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfB1la0BQ+f5QF5Nfi4aoLs9hdI3G61W/EKVxvz+7YY=;
 b=S4DS8fx8yxCmPdFtsLbW26XiHAuKS8CLwmcCNfczuR8n+p0537SO7dceDrrdn80jLFRy7tBKq6WN2dLY3U4af1L06XOq/Hd4/Wx+wMUVpxeM1YOhIENDS/Sensebqrs8EnNuv13O5rvLtsLhUvua2esbbfLfaly682pD4i/67Ag=
Received: from SA1P222CA0034.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2d0::7)
 by SJ2PR12MB9192.namprd12.prod.outlook.com (2603:10b6:a03:55d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Thu, 16 Apr
 2026 03:06:08 +0000
Received: from SA2PEPF000015C7.namprd03.prod.outlook.com
 (2603:10b6:806:2d0:cafe::e) by SA1P222CA0034.outlook.office365.com
 (2603:10b6:806:2d0::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.51 via Frontend Transport; Thu,
 16 Apr 2026 03:06:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF000015C7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Thu, 16 Apr 2026 03:06:08 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 15 Apr
 2026 22:06:00 -0500
Date: Wed, 15 Apr 2026 22:05:32 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<ira.weiny@intel.com>, <jmattson@google.com>, <jroedel@suse.de>,
	<jthoughton@google.com>, <oupton@kernel.org>, <pankaj.gupta@amd.com>,
	<qperret@google.com>, <rick.p.edgecombe@intel.com>, <rientjes@google.com>,
	<shivankg@amd.com>, <steven.price@arm.com>, <tabba@google.com>,
	<willy@infradead.org>, <wyihan@google.com>, <yan.y.zhao@intel.com>,
	<forkloop@google.com>, <pratyush@kernel.org>, <suzuki.poulose@arm.com>,
	<aneesh.kumar@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for
 KVM_SET_MEMORY_ATTRIBUTES2
Message-ID: <a4zojsqgf4bzguys75fujw55gz5fe3glyrc6z7bfawdtyrflmx@rkzrvzbo3j6k>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
 <eiiecl7jvywvqb4drq7cchmcabcrdka25wxr77uavxqineeedm@rfcnhdz6xoxf>
 <3blpenhpvysb2ig7efegedx4v3flppl5ftnz6vhpqlatfk3ycn@vmmhs7mvjieg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3blpenhpvysb2ig7efegedx4v3flppl5ftnz6vhpqlatfk3ycn@vmmhs7mvjieg>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C7:EE_|SJ2PR12MB9192:EE_
X-MS-Office365-Filtering-Correlation-Id: 042b3f0b-77f5-4a70-92e8-08de9b651b07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|376014|82310400026|13003099007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	O8ccTRFjliHYNqgea4Oy5NhcMVI+j0n3qhVv0QTvfSM1N/k/w8+6e5gW9mhId4yNnKik6G0z/9M6WhBrO8AV2CZyYdmD+eID4mYU8PvwBCe5VIqh5cVXwP5Pdk9pXTY40Mbdp8JN8gmyzg4qTA59TomIFS69onQ4vBbnMmYXL+BXztjURb9jAEhNvswTomtTFZhE1cvu+bBrtFYhu4TRfy17S2MNRZtWcF7mnfrBc/aDFdYY0tOMx9RUb9JFm3BZ1BnFS6RZw13NWQ/Z2gcSuIv69C3BtG7bMUpE5JXJtyUJXLsJ9v89I+viEyZ8fazFNpWLDdjIkUCR5bGUxsYDpfuX5R4ioMzDpbvmoPct12t+0/tGgrG051qixAzk/RKZASRUQHquGeQ/mCI2pexbL7E2piURBxSTkUf43SuuHwVbX6vTGyj2pRUvU949Zm2uoZp6EgEzbMN6UHbDfqFv2QzOhXfEjVEutSd9xAdvtsYtE0FUBTVlMcB1wpYGs4O1RGXABuLZkU/AcSAFFFb9EZJTcQgIhTqWygdktRCffKSScbEJWKQG/bMvaXuo/5KYULUg98uzc2Vzxm9JR0yfMqWiGsDMMSqtf9qsWaed/JChdNzSf50o5tYMuRFgOPC2J83V88J1RwUWHse5jF9k8rl8UoQfttcBkj+eDCynncQICTkjubxrdsUDS08Cvds4CMYuRYfN53o7BXj6m8MTfVBZQkol9xDBa3ozuW1J2C2jsVqVX1cdO29f2JAvqrRkzXHCmoellYeOfjB3JEuqFc/b0yNUEsfBrDMoJn4AymA=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(376014)(82310400026)(13003099007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DtVcdwd8v3o0iTxlGvTLPtE3Jn/SDDcEIEtnH9vwdvEngaX5xXxz+ZQgZurnJ5SoTAd/kVGvv6gP4zOPLFTnQw7p3GY+ems0/4JbfaCix8Fvz8PV1l5vZfYBajps7FJQJUnuswD+LG0WMY5JFtwTKklNFoX87o4eoP08pe141a2Zq75F+LbyzhiWd7sbxXs1dcdmYCRIcIjazahLKpjO0tl4DdBZEGtrrPaog0vznPZ9lsvdaCFjqYCbm/FPyp3Vv7S9q5GxreTl41z74pVljxk0Giiu0csE0bJfJmfWVl46QCOWcuDen8fal370MQoUJnl/Ysgd42xGx2ZcqcdxgSSgVWc0SMXpK5e0O4LIFLC++EdzHq57naXJi8Ry1POv/uRImYN1z0HXYf7kdYZwW8stFKHzsj0CDl6H/f/m7yfexssFDhKjq+Eb/5lG7CPB
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 03:06:08.0006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 042b3f0b-77f5-4a70-92e8-08de9b651b07
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9192
X-Rspamd-Queue-Id: 327D612000D
X-Rspamd-Server: rspam07
X-Stat-Signature: ec7yc336c5do9jkgkhsowj45k8erfrbt
X-Rspam-User: 
X-HE-Tag: 1776308774-545477
X-HE-Meta: U2FsdGVkX1+4qEkCqrLvUqyP0ytG+6kpyUqpWpH7nKJhFexOoerkisFCowpeS4I76d+1EwFacd2Eye4QKDiRt0TyBtxH/b9Yzp0eab0eXMP73gmR6XRGlnwAqvXFqpT4bzY20L12/FoROxl8pnRM+lFDPjZ3o3qWEd37P+ZyWjbNjqb+Gp0VakMfqL6k9m6UBiEK/zUAzCqxu62s+0NOHVNHijqvVtJRoBwmkCWK2Ie310sMR7bWChKnDwM8QeBHsiO9wHVpGfG6rDTr8FsuxC/XpajqYWHBM5KvAfR4VkKpKu/Ev3Ng04/km1uMAgts4KPZgDK93wBNEoi8mNZiSX5coO+UFISE0xkDDF9I89EzCdYrcObqJBoanzCC10ylAzTTR4y8m+mYh94Fa5JHScjauA14ANkc0Ax83YQHYz+ujYVpGehoHvZT8bwTzZsCQ2y4qyI0dI38CNsFe0KJgYJu7oPHrYCGB70SsRlAS6Ly2AqT5e9/3eGT3yVVbSoP4j+04Z92vn3ez50PbkADDZFRXuk2d0oMp84Zn4rI1Ex87bR0DCvKhSw/ktfVC5Pe+eT7pVKFpfpqfUz6qLB8FHH18ONumhCEf1UKlQN6pm8qGQF/SGpdkMfDGW9WtqiCPJF65Xc7F4l8oyXb8gECp93wCEevhehuPyZ8HupJUS5Fx2pnAEsdH7KLNEjGJpDHtRNL4uI4VGgWfJtrjjPa1WvkkRGAgmaFmiTq5vHfH0GI6i6f95d+7QPsuf3giwT9W+mkHHfqZxajAMkNexSrkPwX6/+/Du9+N2me+YDo7F7ZqYOzaDizsROEdR7oNQJysHEBij+Nzv9SFi1cBsXseOkXso8ZYf47r1As+NHuCT9M646fJhbaO0q9WhVSSGpm0HDmAMy9bCc6mlJINhq+Uf2E1nBsHOwnV65c1CcDCGux82m1rLf3CsjZ+1jrtM4PWTnkOyv5bUnZUxWmXEv
 6rsGrKRK
 Epq1IPsLb20SL5COJNFylBq8iwm03Nzwolm+0RNOHr8CA6mkdCCun/JduaRnfhvS8Ds4RjQiMEW69NeU7ARO4RCTegzF7BV95KjtVEIY1pyC3nit8zKb3SeoW1BEXlHKIR+PUa+uGIrwADELHpGymrbNY2ScRYza0/U9UcXqKpSotJ5T4323ZKwCyVMHKjoed5UlV8mF1hkJlVOBNvNiIpsBVw2Ok1l/XMQOlFJ4r94S4Z2EAhqdMEiCHZZ+pCQctWU8UmHB1n+nE2e6TbjVeEbrrVUqp5DhyoQlyP52zVCOEj5YCteS3R4CmvrEW6CHDnrCHunuaD3Spe4MTFzvrjGoywacR9VgcTvPaSjDgb7ZJz9PzmeW1IdnionQ2Wde6zSzWUbFyFFE/yifPnnXmqTGDAGu6oyqDEXaXe5viHcZxWZD9QIxHGPe7J/ZcOMKUBt1cKH5XPTrxkXxJ9y+jJ4pReGktCH2gNd1g12OITFJ7fbPPzEk0af3fPEhohaB7n966EIn7dI3Ne70PW4m3zXrNM45ltCCLGt5lKb4EHY/JcHh8V4dqsBiIkhO6FVso93opVoKGXIIfgYYQCHaO5Q/9iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 01:20:41PM -0500, Michael Roth wrote:
> On Tue, Apr 14, 2026 at 06:37:00PM -0500, Michael Roth wrote:
> > On Wed, Apr 01, 2026 at 03:38:12PM -0700, Ackerley Tng wrote:
> > > Michael Roth <michael.roth@amd.com> writes:
> > > 
> > > >
> > > > [...snip...]
> > > >
> > > >>  static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
> > > >>  {
> > > >> @@ -2635,6 +2625,8 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> > > >>  		return -EINVAL;
> > > >>  	if (!PAGE_ALIGNED(attrs->address) || !PAGE_ALIGNED(attrs->size))
> > > >>  		return -EINVAL;
> > > >> +	if (attrs->error_offset)
> > > >> +		return -EINVAL;
> > > >>  	for (i = 0; i < ARRAY_SIZE(attrs->reserved); i++) {
> > > >>  		if (attrs->reserved[i])
> > > >>  			return -EINVAL;
> > > >> @@ -4983,6 +4975,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> > > >>  		return 1;
> > > >>  	case KVM_CAP_GUEST_MEMFD_FLAGS:
> > > >>  		return kvm_gmem_get_supported_flags(kvm);
> > > >> +	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
> > > >> +		if (vm_memory_attributes)
> > > >> +			return 0;
> > > >> +
> > > >> +		return kvm_supported_mem_attributes(kvm);
> > > >
> > > > Based on the discussion from the PUCK call this morning,
> > > 
> > > Thanks for copying the discussion here, I'll start attending PUCK to
> > > catch those discussions too :)
> > > 
> > > > it sounds like it
> > > > would be a good idea to limit kvm_supported_mem_attributes() to only
> > > > reporting KVM_MEMORY_ATTRIBUTE_PRIVATE if the underlying CoCo
> > > > implementation has all the necessary enablement to support in-place
> > > > conversion via guest_memfd. In the case of SNP, there is a
> > > > documentation/parameter check in snp_launch_update() that needs to be
> > > > relaxed in order for userspace to be able to pass in a NULL 'src'
> > > > parameter (since, for in-place conversion, it would be initialized in place
> > > > as shared memory prior to the call, since by the time kvm_gmem_poulate()
> > > > it will have been set to private and therefore cannot be faulted in via
> > > > GUP (and if it could, we'd be unecessarily copying the src back on top
> > > > of itself since src/dst are the same).
> > > 
> > > Could this be a separate thing? If I'm understanding you correctly, it's
> > > not strictly a requirement for snp_launch_update() to first support a
> > > NULL 'src' parameter before this series lands.
> > 
> > I think we are already sync'd up on this during PUCK, but for the benefit
> > of others: Sean pointed out that if we don't then we'll need to add yet
> > another capability so userspace can determine when it can actually do
> > in-place conversion for SNP.
> 
> (in-place conversion for SNP during pre-launch/populate phase, I meant)
> 
> > 
> > Right now, this series effectively advertises in place conversion at the
> > point where KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES reports
> > 'KVM_MEMORY_ATTRIBUTE_PRIVATE', so I slightly reworked the series to
> > include the snp_launch_update() change prior to that point in time in
> > the series. Thanks to prereqs and changes/requirements you've already
> > pulled in, it's just one additional patch now:
> > 
> >  KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE 
> > 
> > I also did some minor updates (prefixed with a "[squash]" tag) to advertise
> > the KVM_SET_MEMORY_ATTRIBUTES2_PRESERVED flag so it can be used by
> 
> Though I'm not sure how we deal with it if SNP/TDX at some point become
> capable of using the PRESERVED flag *after* populate... but maybe that's
> too unlikely to worry about? If we wanted to address it though, we could
> have both PRESERVED and PRESERVED_BEFORE_LAUNCH so they can be
> enumerated separately from the start.
> 
> > userspace for SNP/TDX in the kvm_gmem_populate() path as agreed upon
> > during PUCK.
> > 
> > The branch is here, with the patches moved to where I think they
> > should remain (or be squashed in for the [squash] ones):
> > 
> >   https://github.com/AMDESE/linux/commits/guest_memfd-inplace-conversion-v4-snp2/

Argh! Sorry (again), I just now realized there was a typo here, this is the
tree I'd intended to push (and what was described in the original email):

  https://github.com/AMDESE/linux/commits/guest_memfd-inplace-conversion-v4-snp3/

-Mike

> > 
> > I've also updated the QEMU patches to use the agreed-upon API flow and
> > pushed them here:
> > 
> >   https://github.com/AMDESE/qemu/commits/snp-inplace-for-v4-wip2/
> > 
> > To start an SNP guest with in-place conversion:
> > 
> >   qemu-system-x86 \
> >   -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
> >   -object sev-snp-guest,id=sev0,...,convert-in-place=true \
> >   -object memory-backend-memfd,id=ram1,size=16G,share=true,reserve=false
> 
> Sorry, that should've been:
> 
>   -object memory-backend-guest-memfd,id=ram1,size=16G,share=true,reserve=false
> 
> > 
> > To start an normal non-CoCo guest backed by guest_memfd with shared memory:
> > 
> >   qemu-system-x86 \
> >   -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
> >   -object memory-backend-memfd,id=ram1,size=16G,share=true,reserve=false
> 
> and:
> 
>   -object memory-backend-guest-memfd,id=ram1,size=16G,share=true,reserve=false
> 
> (and both require kvm.vm_memory_attributes=0)
> 
> -Mike
> 
> > 
> > Thanks,
> > 
> > Mike

