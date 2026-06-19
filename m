Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C191ACD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 12:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2DC16B008A; Fri, 19 Jun 2026 08:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05026B008C; Fri, 19 Jun 2026 08:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CCF66B0092; Fri, 19 Jun 2026 08:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CBA26B008A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:28:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 029C7166657
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:28:47 +0000 (UTC)
X-FDA: 84896591136.09.B089604
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011038.outbound.protection.outlook.com [52.101.57.38])
	by imf31.hostedemail.com (Postfix) with ESMTP id D815E20002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:28:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="rBGmarN/";
	spf=pass (imf31.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.38 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781872125;
	b=F/FSgDMMXQRVzc+WqbHdYCdCXKBC6yyR8DHOHL2hwjnb6w+1ThtqQXtOPNcAjHTefDh1nn
	fVjCUMu9l97bWPD7/G7Cuxwnv4TAhLQvXxOVL3urRMSrdx9K8Qzj++Jwl7YNNfMDigJQXS
	Ptn5kNqI3U7dcBXK2HX9UOItqBS2DZw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="rBGmarN/";
	spf=pass (imf31.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.38 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781872125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sf4FqwlcijwPGq7fC2/hHTWvNyP18M4EUm8vq3o4lzI=;
	b=XSkyOK3BSM4rnI8fOczJ6mUB3oqKeQh3RLGANrXVo1QdzZbRGA/D6/1y44EzY2IJ/zvtef
	TycnMGor7+95lZuN1qnx1lHS8eXcvDAeo1j0CP/Bj/uLi+L+VgX3Ckvon8aW8HLfYVbbVm
	dtWzaHjxHcaR8lEioHvD/GlrNONl6/A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HD9iWBPdKxb+1fAZ+ybj8FnSVW46NXf/LGgYnDzOBg5f4AUyjOBD5/QFAFE7fGnTO7MJHu++B9vvpTogWWRdf/CI31URBBCLGg45Zh0AbftEFCqDYMdQdQojcwEdACfzWYVT86RWEjMKGtfCnOOa5D/2DdAuQ9APJAnJ1h+4v820QGsn3MM1uCd2HLWjpK1dLHXa6YTGrQqNKMGsAvYrTcOyzSubmAMY2A0Oo9jQRrUqYVmYAptagfn+QWTiHeWM56pZ4ZvIm3TYiIpPE5iBgOVdEzBPQ0nwimdIHRVxkAB+8kooV5OO5wrQaoLRSA1gQ9Tc8Oe7lV++jyIkQtzc5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sf4FqwlcijwPGq7fC2/hHTWvNyP18M4EUm8vq3o4lzI=;
 b=mIHJ6RRIZbLSR6TiE4N78aX7HnfDiwkGWuTJCikOSop+tpvkGq/XZC/sPvAinUhpnG5apDYtpYa3vdZThKNwBSfHMX4s1pxUmF5KoTPWB2vdbQSAHz+hb6eeOTtEIggaGUZTnDch13mLh2yuFTaWxUzDK7mcDtCkGLLxOZXzwIpdu0GLfwGS/6HsBhLoxIX96bH/SeiQyXLG8dM72GlE371OjZQoJxrtdBJf55Qgg+VyqpUkq/9F+RpS5yd72XTveICsOVYHNU7iosW4vMihaeJVoFg8MRuHt+GRiHs1tAP99xVpneMbUd7nCEdULWlCW8+HSHCyut/pKt9aIg4BIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sf4FqwlcijwPGq7fC2/hHTWvNyP18M4EUm8vq3o4lzI=;
 b=rBGmarN/ENMU7QFN8jCF80eMlgww+4yxbR+YhkOlhgymFAkPMRIdgdC4Qm06ppY1Hdghnhgi3BYIukT9e6re7YXAR4W6qN4r2zikbEfbRs4qb4avchQZ2pUsMIjbaoyom/2omx2ks9Ra7I0mwcguh1Hnr1PLiViOCBEg89BQvSE=
Received: from MN2PR07CA0003.namprd07.prod.outlook.com (2603:10b6:208:1a0::13)
 by SA1PR12MB7442.namprd12.prod.outlook.com (2603:10b6:806:2b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Fri, 19 Jun
 2026 12:28:37 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:208:1a0:cafe::10) by MN2PR07CA0003.outlook.office365.com
 (2603:10b6:208:1a0::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.13 via Frontend Transport; Fri,
 19 Jun 2026 12:28:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Fri, 19 Jun 2026 12:28:36 +0000
Received: from [10.128.112.233] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Fri, 19 Jun
 2026 07:28:22 -0500
Message-ID: <a6373206-60b6-454c-9aa9-9d52f9d84de3@amd.com>
Date: Fri, 19 Jun 2026 17:58:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/46] guest_memfd: In-place conversion support
To: <ackerleytng@google.com>, <aik@amd.com>, <andrew.jones@linux.dev>,
	<binbin.wu@linux.intel.com>, <brauner@kernel.org>,
	<chao.p.peng@linux.intel.com>, <david@kernel.org>, <jmattson@google.com>,
	<jthoughton@google.com>, <michael.roth@amd.com>, <oupton@kernel.org>,
	<pankaj.gupta@amd.com>, <qperret@google.com>, <rick.p.edgecombe@intel.com>,
	<rientjes@google.com>, <steven.price@arm.com>, <tabba@google.com>,
	<willy@infradead.org>, <wyihan@google.com>, <yan.y.zhao@intel.com>,
	<forkloop@google.com>, <pratyush@kernel.org>, <suzuki.poulose@arm.com>,
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
	<nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen
	<axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau
	<kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-coco@lists.linux.dev>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|SA1PR12MB7442:EE_
X-MS-Office365-Filtering-Correlation-Id: ec2866c2-1d07-4e9a-730d-08decdfe493b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|82310400026|36860700016|13003099007|22082099003|18002099003|921020|11063799006|3023799007|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	jOWGJb30pE2KbyriwilkFoCGJllUemD+QC4E91CEbqnn0sHvbseiyTTafmMEVcK5Hpvp3JO9YoL+o9aOcT3W7meeTu6udm/gLzLh7PvP1vRtMTceK8GNgK9paPCHnkZcWTOPTK0PM8xQSfeRY1mc0CdbyZJIb8sv8osO64HpGoQvthjUKy2Cn2eSa4NiJjK4Vtn9maum1sVu6YMQi3FaiQfF8JTIcN0f7J+RFlhsMtBD+j2t0bsmMWwWCPXxqgzlf8I2XLPqYg0ODoyWvlo9NhKAuXZMNi25bRX+/1zxjTuZIKS4D31RF27mCAfhM5n5QaXkeDVBOtperdRLWipQ1igGTg0n5EEHRW1cIvseCNoPYdHU9ODQTdRftu0Cp6L+6HmqwtA7Gg0952Szp8i9X8x2JffMlU+IJjIltu/sjlqUVmUDKfX5gK34Zs+UotN8xTkE6TSUdGiHubrdyrAeV1Ds4sosuGS4ApxHrNJ5yuOhr7IqNHqbRsaiVcZDh7duYTmD3avMvlUtzM538eoJHdlIPYHqY/pfW8Gyu0PHs7e+PgWyfYoGimybB38LiDzgQDJoDVLito4XxUmtCZ8NIGHGHykugpis9ep1hYtUDc8voXd8D+5ol68g6cQpI0pc0xu+4aXIU/siDcQuOzcWT15KeuAkByuy/qNfzHQBJlqyuO8pQ2CMLsW3OAuQZMDIS9KwGyCFMVYyjgfV9BiM3A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(82310400026)(36860700016)(13003099007)(22082099003)(18002099003)(921020)(11063799006)(3023799007)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jTAbi/Np9VYwZiygxUapcrPx7ngDG5oan0qBlEZsSedn0LOPo8Hz/fKDXCTlue6froZU3hHN/1m1yqDoLFs4Zm9RfPtaFYyj/zPkY6VTMkvOJFi5D/7pearTmzRKBCOgggj/nmkfGrcja79L13JLpyZaPduQM4XNBJz3muDP7AVOEZHUqN65q4dDCrhtCAuP1Qtua//x4gNqZcd4xQZCPPYB/coPEQQnCpUeUILuo+4olNDUCA245vCsfsj2jQKv3ufu1SC2triolR4BHzm/wM4e0nDs6yiIqguvXdoSPMfELmTwXG1NnPHfEHA5wN8ss3vAFSALlw79DZ8V6RBZcxRFK1aWyelrZSvJMMEuZHD66SkdHRA6AKN8VCYXfjCdVUhyy3GWxFOYUi2xhznywArYo9iQtaPAw+Tco9g2a2hCDv0MIGPRZBhVgJJwEcT0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 12:28:36.6780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec2866c2-1d07-4e9a-730d-08decdfe493b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442
X-Stat-Signature: n9fbranwh6rzt8r4skxra8ytiipnz1m5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D815E20002
X-HE-Tag: 1781872124-444883
X-HE-Meta: U2FsdGVkX1/YEIwVyuJSoF69Rt1f6+GD6Fzn+3XCPGlARHXXYY0WpsYVgYQZW0yHd9eiibMYMTSCzyRcSOhSXfbcQvo8MzKvs5B/Yf6fXT6UfUMqK+ywhT+tVN0Imda5T4KhMqQJQUkIBhFkjxbkzsD4J+Fml/VW/bfeDYF5M9rJaU/QFhJN/irOsM7ZWhslhOmqDt5LPWrNQs1Q35Wu1kcgqIH7inKBN7OKVGni4VzFFlweKNCQEtZvf8Ns+B1pu5or3qumzhQyOugkTLkdOLmghJQINPMzL5YZDEU3DD/NjW3j0oVM4zFK2jR3Kb3IY4PbwhbpqyvNeusjGF0Vq3FySq1x658ghaDt36x5yXQJneh4qGBLspiDhAinReZ1d90Nbj7u0iOeiu8xTeWU5beAyg6lkU+p7FC1iIx/7yj6cBrzpDdlEDyC7XDR17uuTTNFBGBCmPvxdmpeYDsJxEtAdRk6q6CSI7yRlSROR4ru0NNlvO4tO3r4QB6649X6QlSAhCmSTQYMCwbK2EKZjpz69EZz2luqdDJZLi/XhNAuebvJXxRgyqQ3s5xMux/w6yXRweEIiyEBVI9y2BMyBtTKvwXNSsDe4Xt87F2aOz8OdYjvos0wulRS9ciTcCgJRY/Izo22PeBeBPpuZhxvkziGTd+URJxXJosrMAnj3wyHC5NXEeiC+X5t+T7aC3H9DghEyDk80XrLdmQeeJaLYrn3bo6ihtaMaLGmwBIeGy0kfZZ612ifh1KGLOmZGv8IFdC4ekipjtO1DrwOVCFG5Z9+/hsuh6/bgTGMI82ZFVLON8JoaEsGw8MTajo+EsqqxPB3qDulfI5mSssbcU5QSL5kh0NikDBDwS6HypyiDQjjv630TZB8D9xP61N6vzNdkOKgHf5bo4rmSebzTnZQhJ/6ItIAru4Cxl2iNLdE0f6hmb+PwmIU5U5/eZEl846dq7J1JYga+upI+THZf4C
 dkZtmC8j
 XvOfPojN6zUjwbRA4X0hlTk9c6EecDSEIFNsKZnJmsP8qVJ03nbhC5tJjI8kmCCD/NIVN1fLbe7HLs+Wz/bcUq9Z57Pt7KrI9NqR2O5ieplzoIecR+8ZR/dmEGwFp7+UqL1XKhRQaweWTPFGPpx0kKwvySvangG6UsMQ16HTLUSfPtjeYjCMlX+5m0S6Iun6eZrLfe0iV3Y0NqvgXmuA4n2T0g/ThgVVRRgRTlmNsEJLgn+lqA+1084n4U7TGo/NDTr7RQ2lDxTNcCaCFF0WvwrMsQed0IVSwItBSuZXdk06gGLBVV+8Y0SodIlzaAfse8h5M3FJ0+bkEMJFod2XVSaglWneyNUIhbJnpBfz4ZaHcibdHSB+oxQ4pdrNSByKuRTWc0N8CdMZcpf2MnMWlwEmxtv2yA9w0YD6f4EG+LQStS4xyyCMk79FrtNSrA7bklOUl96t3wkFnWjbzUdDoCEJiHP4dqITm2kmQpJA3woI8KUBzw/Ir2eN+mH+82vFfebOtgaObyRK0yy+UGlxNMzHU2pe/ZHnmq+aY13UN1t+8jC1KpMaWlg/GHrUa612Z+fq3Ez1+3l2K8mSFxsSuOyQrFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/19/2026 6:01 AM, Ackerley Tng via B4 Relay wrote:
> This is v8 of guest_memfd in-place conversion support.
> 
> Up till now, guest_memfd supports the entire inode worth of memory being
> used as all-shared, or all-private. CoCo VMs may request guest memory to be
> converted between private and shared states, and the only way to support
> that currently would be to have the userspace VMM provide two sources of
> backing memory from completely different areas of physical memory.
> 
> pKVM has a use case for in-place sharing: the guest and host may be
> cooperating on given data, and pKVM doesn't protect data through
> encryption, so copying that given data between different areas of physical
> memory as part of conversions would be unnecessary work.
> 
> This series also serves as a foundation for guest_memfd huge page
> support. Now, guest_memfd only supports PAGE_SIZE pages, so if two sources
> of backing memory are used, the userspace VMM could maintain a steady total
> memory utilized by punching out the pages that are not used. When huge
> pages are available in guest_memfd, even if the backing memory source
> supports hole punching within a huge page, punching out pages to maintain
> the total memory utilized by a VM would be introducing lots of
> fragmentation.
> 
> In-place conversion avoids fragmentation by allowing the same physical
> memory to be used for both shared and private memory, with guest_memfd
> tracks the shared/private status of all the pages at a per-page
> granularity.
> 
> The central principle, which guest_memfd continues to uphold, is that any
> guest-private page will not be mappable to host userspace. All pages will
> be mmap()-able in host userspace, but accesses to guest-private pages (as
> tracked by guest_memfd) will result in a SIGBUS.
> 
> This series introduces a guest_memfd ioctl (not kvm, vm or vcpu, but
> guest_memfd ioctl) that allows userspace to set memory
> attributes (shared/private) directly through the guest_memfd. This is the
> appropriate interface because shared/private-ness is a property of memory
> and hence the request should be sent directly to the memory provider -
> guest_memfd.
> 
> Tested with both CONFIG_KVM_VM_MEMORY_ATTRIBUTES enabled and disabled:
> 
> + tools/testing/selftests/kvm/guest_memfd_test.c
> + tools/testing/selftests/kvm/pre_fault_memory_test.c
> + tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> + tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> + tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
> 
> Updates for this revision:
> 
> + Updated the series to _not_ deprecate all of VM memory attributes, but
>   only deprecate tracking of the PRIVATE attributes in VM memory
>   attributes. This takes into account upcoming RWX attributes support,
>   which will be tracked at the VM level.
> + Reshuffled the earlier commits that deal with preparing KVM to stop
>   seeing VM memory attributes as the only source of attributes.
> + Addressed comments from v7
> 
> TODOs
> 
> + Retest with TDX selftests. v7 was tested with TDX [12], but the setup there was
>   wrong. Conversions were successful (no errors), but the shared memory being
>   tested is actually in a completely different host physical page.
> + Retest with SNP selftests. v6 was tested with SNP, I ported that to v7
>   and those ran fine too. Just need to double-check for v8.
> 
> This series is based on kvm-x86/next, and here's the tree for your convenience:
> 
> https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-v8
> 
> Older series:
> 
> + RFCv7 is at [11]
> + RFCv6 is at [10]
> + RFCv5 is at [8]
> + RFCv4 is at [7]
> + RFCv3 is at [6]
> + RFCv2 is at [5]
> + RFCv1 is at [4]
> + Previous versions of this feature, part of other series, are available at
>   [1][2][3].
> 
> [1] https://lore.kernel.org/all/bd163de3118b626d1005aa88e71ef2fb72f0be0f.1726009989.git.ackerleytng@google.com/
> [2] https://lore.kernel.org/all/20250117163001.2326672-6-tabba@google.com/
> [3] https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com/
> [4] https://lore.kernel.org/all/cover.1760731772.git.ackerleytng@google.com/T/
> [5] https://lore.kernel.org/all/cover.1770071243.git.ackerleytng@google.com/T/
> [6] https://lore.kernel.org/r/20260313-gmem-inplace-conversion-v3-0-5fc12a70ec89@google.com/T/
> [7] https://lore.kernel.org/all/20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com/T/
> [8] https://lore.kernel.org/r/20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com
> [9] https://lore.kernel.org/all/20260414-selftest-global-metadata-v1-0-fd223922bc57@google.com/T/
> [10] https://lore.kernel.org/r/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com
> [11] https://lore.kernel.org/r/20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com
> [12] https://lore.kernel.org/all/20260605134153.204152-1-ackerleytng@google.com/
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
> Ackerley Tng (27):
>       KVM: Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable
>       KVM: Enumerate support for PRIVATE memory iff kvm_arch_has_private_mem is defined
>       KVM: guest_memfd: Introduce function to check GFN private/shared status
>       KVM: guest_memfd: Only prepare folios for private pages
>       KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
>       KVM: guest_memfd: Ensure pages are not in use before conversion
>       KVM: guest_memfd: Call arch invalidate hooks on conversion
>       KVM: guest_memfd: Return early if range already has requested attributes
>       KVM: guest_memfd: Advertise KVM_SET_MEMORY_ATTRIBUTES2 ioctl
>       KVM: guest_memfd: Handle lru_add fbatch refcounts during conversion safety check
>       KVM: guest_memfd: Use actual size for invalidation in kvm_gmem_release()
>       KVM: guest_memfd: Determine invalidation filter from memory attributes
>       KVM: guest_memfd: Zero page while getting pfn
>       KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
>       KVM: guest_memfd: Make in-place conversion the default
>       KVM: selftests: Test basic single-page conversion flow
>       KVM: selftests: Test conversion flow when INIT_SHARED
>       KVM: selftests: Test conversion precision in guest_memfd
>       KVM: selftests: Test conversion before allocation
>       KVM: selftests: Convert with allocated folios in different layouts
>       KVM: selftests: Test that truncation does not change shared/private status
>       KVM: selftests: Add helpers to pin pages with CONFIG_GUP_TEST
>       KVM: selftests: Test conversion with elevated page refcount
>       KVM: selftests: Reset shared memory after hole-punching
>       KVM: selftests: Provide function to look up guest_memfd details from gpa
>       KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
>       KVM: selftests: Update private_mem_conversions_test to mmap() guest_memfd
> 
> Michael Roth (1):
>       KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE
> 
> Sean Christopherson (18):
>       KVM: guest_memfd: Introduce per-gmem attributes, use to guard user mappings
>       KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
>       KVM: Move KVM_VM_MEMORY_ATTRIBUTES config definition to x86
>       KVM: Decouple kvm_has_arch_private_mem from CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>       KVM: Rename memory attribute APIs to prepare for in-place gmem conversion
>       KVM: Provide generic interface for checking memory private/shared status
>       KVM: guest_memfd: Wire up core private/shared attribute interfaces
>       KVM: Consolidate private memory and guest_memfd ifdeffery in kvm_host.h
>       KVM: guest_memfd: Enable INIT_SHARED on guest_memfd for x86 Coco VMs
>       KVM: selftests: Create gmem fd before "regular" fd when adding memslot
>       KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
>       KVM: selftests: Add support for mmap() on guest_memfd in core library
>       KVM: selftests: Add selftests global for guest memory attributes capability
>       KVM: selftests: Add helpers for calling ioctls on guest_memfd
>       KVM: selftests: Test that shared/private status is consistent across processes
>       KVM: selftests: Provide common function to set memory attributes
>       KVM: selftests: Check fd/flags provided to mmap() when setting up memslot
>       KVM: selftests: Update private memory exits test to work with per-gmem attributes
> 

Hi,

Thanks for this series.
This works well for me on AMD EPYC 7713 (SEV-SNP enabled). I tested:
1. KVM selftests: all tests pass.
2. Using in-place conversion QEMU branch [1]:
qemu-system-x86_64 \
  -machine q35,confidential-guest-support=sev0 \
  -enable-kvm -cpu EPYC-v4 -smp 8,maxcpus=8 -m 120G -no-reboot \
  -object memory-backend-guest-memfd,id=ram0,size=60G,share=on,host-nodes=0-1,policy=interleave \
  -object memory-backend-guest-memfd,id=ram1,size=60G,share=on,host-nodes=0,policy=bind \
  -numa node,nodeid=0,memdev=ram0,cpus=0-3 \
  -numa node,nodeid=1,memdev=ram1,cpus=4-7 \
  -object sev-snp-guest,id=sev0,policy=0x30000,cbitpos=51,reduced-phys-bits=1,convert-in-place=on \
  -bios "$OVMF" \
  -drive file="$DISK",if=none,id=disk0,format=qcow2 \
  -device virtio-scsi-pci,id=scsi0,disable-legacy=on,iommu_platform=true -device scsi-hd,drive=disk0 \
  -netdev user,id=net0,hostfwd=tcp::8000-:22 -device virtio-net-pci,netdev=net0 \
  -kernel "$KERNEL" -initrd "$INITRD" \
  -append "$ROOT ro console=ttyS0,115200" \
  -trace enable=kvm_convert_memory,file=/tmp/convert.log \
  -nographic -serial mon:stdio

   The guest boots successfully and run memory hogger. With this, I verified the
   shared <-> private conversion logs (trace_kvm_convert_memory).

3. Additionally, verified the NUMA placement for SEV-SNP. With this series,
   NUMA mempolicy support for guest_memfd [2] now works for SEV-SNP as well.

[1] https://github.com/amdese/qemu/commits/snp-inplace-rfc1
[2] https://lore.kernel.org/kvm/20251016172853.52451-1-seanjc@google.com

Tested-by: Shivank Garg <shivankg@amd.com>

Best regards,
Shivank

