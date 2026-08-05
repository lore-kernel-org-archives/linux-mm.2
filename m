Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 639FDC56202
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D05406B0092; Wed,  5 Aug 2026 02:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8EB56B0093; Wed,  5 Aug 2026 02:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92A56B00A1; Wed,  5 Aug 2026 02:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76FFA6B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:41:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1B9F40203
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:41:48 +0000 (UTC)
X-FDA: 85066270296.09.BBAF981
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012044.outbound.protection.outlook.com [40.107.200.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id C0EBCA000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:41:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=HcNkNgk4;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.44 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785912106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wb5cEvLHp0OlCkZ1kwUW+yulx3ll561bdMS0g7x2yOc=;
	b=DgOmuv2LC17y2a3EYUTJnm33fRJJTjS7oANZGrpi84He4wcyTJVyu9mrx9zgfuDewl6fF/
	B+NpO6X27lMgLye/z6ltREXNqhYeL1jOPBnIMkMynz7oyvaImJop4QX4Zoiy+THE/+nbtq
	cfemBwqAzRORQRb7hNv3MnHU0xfTU34=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=HcNkNgk4;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.44 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785912106;
	b=HIDkVffupvgm6BZsRu6GUFhZneR3+gEPtZntEMn6SY8uGNT9onbcGjFbD57BI0NEUDFaCL
	jx3ID2UfFiJlSTc23kM2T3h9G4WEBq8/yEJL8u6H3wFnZXTox8o9hJNG8z5h01bVrG9N/7
	0gCMMql5RrKwvjE4qwLIm2qwJE9Gb2k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xgU+jjDr+6cFzGofPHdeN2zRSppaKSnOU357URVNI8j30J/9b3Pb595px33y+XbW3xmlimn3XW9EGoeegKsCBrJ6kmszulqijDtKqU6f8OWOGxaqWjYgxqCWBZkHvha+nbVrnvhpcrf7dnXutZX5VMM9sfCql5jGBJcSQxRFkhWb+Mamt6jEPafN7XnBZCucBWmZLzKYcMUfW3TG9gAhsCwAmaecKayCaYNCSrBN4YnvVMeKt+1Or0nSrP8/ZCnbn+5qNNnB1sPpKiXjZILXdX8DYVxvBaGgorI4eCF1CQLrF1xgRrIZQ5Vs3tVwtg4RsJ3Lyh/7+q9rhcKNSQBwEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wb5cEvLHp0OlCkZ1kwUW+yulx3ll561bdMS0g7x2yOc=;
 b=O6do9QXsWr63rGp/wjqMZ1tgJ8fpFxo80btU68kC6fnxiXrXTrXcGShpajcK38XHYu34U42W66c089ai45kjQXXeHbNDWEFGUx6xOmooMTopO6h1w2sHN8HXGmPCluw8nZZCfLLCf13PmhYTwPbF9V0EiKcB+lmjlfd+uWUtg/8JNX06+hTFB0MAVF1xQ5GaUzROtlGU0zIBHd8zNLLUrenEg+QujRe94tnj+YvTa86GmUTGtKIHMY3O3i5MmMtMGdTl/t401X5h99P+vphREh5T3jUkPijEQjYAfBd2bwO6X2aasgifmSXdY90RIZsitb4P2KdCPFUg5Fdzv82eIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wb5cEvLHp0OlCkZ1kwUW+yulx3ll561bdMS0g7x2yOc=;
 b=HcNkNgk44DPGSRGzrxGvH36ghSjjNwouC4vwVdmeBczH+WWczC8aDhIXwrVlqqrU8wGE6WrY7MvBO/ejkh3PFdGF0hLFL+WuAbROgRQmf4EbspZ+G2GPLIXFWNNru91/jG/HIffX96sx+R0+05/x5kfZjui26ye1vXgpcbOA/q8=
Received: from SJ0PR13CA0097.namprd13.prod.outlook.com (2603:10b6:a03:2c5::12)
 by SJ2PR12MB8692.namprd12.prod.outlook.com (2603:10b6:a03:543::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Wed, 5 Aug
 2026 06:41:38 +0000
Received: from MWH0EPF000C6189.namprd02.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::86) by SJ0PR13CA0097.outlook.office365.com
 (2603:10b6:a03:2c5::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.16 via Frontend Transport; Wed, 5
 Aug 2026 06:41:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6189.mail.protection.outlook.com (10.167.249.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Wed, 5 Aug 2026 06:41:38 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 5 Aug
 2026 01:41:23 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 5 Aug 2026 06:40:31 +0000
Subject: [PATCH v3 2/9] mm: split AS_UNMOVABLE back out of AS_INACCESSIBLE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260805-shivank-gmem-migrate-v3-2-00d8bdec4e1d@amd.com>
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
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785912059; l=6122;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=JxMj0y/S7bFLlD1nwUvnMUQhs3qj6rMOH/yENOwr9I4=;
 b=2XuNYeCPl49Ii4Rs1HQcchjrB0786BJfqQSmKd8m3icYgH/W5p5fr8NjEb0XpDMXWAZ3Uo6Vn
 5HcT1xCv+s/BYD1JJyHa1riG8y34kBAJMmT6sgFXwa1DHhf4qzXqbq1
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6189:EE_|SJ2PR12MB8692:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a905a83-6897-45ef-cb3d-08def2bc99d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|82310400026|7416014|23010399003|11063799006|10067099003|56012099006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	ErlsFPdngcH7s5uYWP4kV9qEJuPMHubOwK3c2mzUsge3p6ZEWEIpqsJ2Buy7YQ4VWpM8PgZlabgLvPXBlBhasoj4XmfN5gjvyQQ1FKEvPnEZhhlTkqg3KZbOHynIKQjLzlKNawDo5hTogRe43vr29F+wVvX3jGR6Zea3JAAd3IC7HhFrsHNk/4i7W34aOZ7U/b6fL3fsJB1TrH9YKKNhSzJ5un5pS0ykowa0/qzfOh68O/aiwC+HusXLdM0y9uAlQAX7/92uW6sIZlcBBHA7nKYQMOTisvw4B9vrg2apT5IsjeSEHRDHVtgUBvpyg66cXKGsIK7nF390lsH5L8CZc6+YUUzBV/Fiud7MsDGXbLMGtmRjJvdCziH2qr+kW652Dp0x3j79gHkDGlvZl61T++lNao+NhirWo7ocLjA9L0FlVEJ8ZlV3nY6qnj4R7GjYyxkdHFEUIY1YS0TSlVGqOfCEfb9wFleMyPPFtwhTbIOkLI++NqiZtKSfYcucXQxWXz2Ql+Vt/nFtwR6n0pYz8Z0++sbkKHntrRWnnuRtH2Tv6m+47wYfCVQ30fE5hxnmerk/nc2ZvHfsSiwfQ82y6bxxwq8apC5w9KWqGMx+uJohhikXTpd6Gt8sWvReB0aRUjnt3k4KpouMhBXtz89D6FBjNsUKomkj1d8/Z5oNucXC+LNChyOx5zLqo0SIXJufI5E6IOmmclEcEbfAroDiueYQGv9qrVqKboOBjy7Ima4yqbxFoLgN7wSTe1xBZpcr
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(82310400026)(7416014)(23010399003)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	01W4IImRINZWw/pcCL9qJpPsOO2KcKbbdHCUozfFRRF8HbuF0s48LuDw8ntNq43PgPtCa/M62r0gRKYQ/XfT/E3KbanXxeAXjtHGpK1RIThaBKAQb/3o+foFSeRyAvKMEGqBH69GhnATB/8uEDLiNvCwY2l0qpz+cY6sG2D3b87LL8ioE5BmWRkXrcWIcKijSRr9gRUe7Bd9xn983paawXmwD2a5zX6kzsKJn65REbkNN0M0MTcgowSc8CSj0InMAKNBsDAIaoQrn7ADEc2kKiaPMPKmI2D2AQdDrTiOUF8GYf3LcPi6S1sEPyV38IQ1VB9+H4KTAzTPxXgXC0FdzJhku18khis7fCyxxiCrzL6uf1Tiqm1JEH9BU5K9F2ZsmlY07zz9ubkGnMah4wO7fOh5dLK7lbP3Tiydgk5agCQuiK97gQ/0juYVBs4U6z3z
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 06:41:38.1057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a905a83-6897-45ef-cb3d-08def2bc99d5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6189.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8692
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C0EBCA000A
X-Stat-Signature: jbhna5cz4qxs8hi5d3wp8enhpfkt1uyz
X-Rspam-User: 
X-HE-Tag: 1785912105-89511
X-HE-Meta: U2FsdGVkX199wvE47q4pgKLRre2YFuaFJNdoJck3mQ3qVtfJTQ20TC1/jMYQBbKgIDQ3YBoChIayfeVoLrOUBdxnVUFgW6WQy9O+iqallulP2v3CkMu9c+KtIJw4CwvqiqAo4sk38fQ1NYn2ZDo8z+RL0CWAWMIob+mUY+ZVw1SZLVuf+JT/HmBhAMTsJJnd/hZUl4xt5J1zqXRcd5tDm5oPkWKOOOcZJS6cLhtvP6rwBngxtKwQf2fofLlFuCkH47xUz+gh5JwmgtWwF2Baj2nkkT4K5HLxGnrKi0RMQaXgItbY+DesWmLGDNA2c9sibbPUVb+X7wnIvp+eXEQvu3nP2V6TcsrBx5wWeCHwADNXztrBGpqTknm03XTYCU2eiqmoUmXSQJaquW4+6+L/yLxLdrKE6SRhBnjGIV4xGm56mKtBIksyWmvwchwP2+5K7RpYFTdHPhh32Ow4/mOr2ekkVKBBTmFzV4RPdbvwtXTL+M7Ghoxt7qX7ii9W74+CfzIUYNVoWmdSYyRrsWPyvyASbbL4/k+dVSk93oso9HX5D/ohm81dfTY8gKoGbqPacSIRVxtIEJu8wso59q8JK5Hcgyz+ddsT2mim0ayFij3z3AK65HZrf+LWpgsA5+ERjVjp6MFIlJJ8BTM7DT+TVCbGNLe3yd/2vBD3bxKuq40p50OssLWSIIQb9PvryKOBOQkxCuPl7cBtnU4/6D94ZFUyuCrG6pzoAX6mVLFtvEpqEiG4ihjHcGW4AlFkKM7oQXevYL39XkGoM3eGOkW7HPpBFW7T88r3p9Y0lxnwV4mYBKCSiRt6Q+iLKB0DYJbXtOfz0slDspugk52gUxMZnG6cO2/82VXz/IDe+yIUHSmpYDHSfWtaPSFvvhzvBmnfaPPX3zjXvROtljPdk6reItbBb32jy2oywJUUnuXcUHO8L1t4nUNJ0DcJMtxOZ3Tf3OMorJc6RkCE79fbG9Y
 28sjPXI7
 pDyPRLO27FBElCOOM77DcZffwLVwOnhN3H2arsG+2B6EOa14VXB99qpBRSUuOM2UP7FTIrvMB4HXkTR2ZpQ4cibIOHOvKzxcetsc0RxNglbpTAdqsr7tVO4V2dw9/7tcNQrv91Z79xS1Z6dqPxyQGn8mRg213YMxdHGqoDr3TuYsV0yt42Kj/DzmekatOqL/5joVrqV6xMG1kIm8oV6T+Cj5FUhoDmhT2ua06tlpE5LSpQnyoxj8NEXBv3C2cQyJixYy+Ezrs9XNpNgSmIocJf2KoJkCFUvMIO9cqD3RFwYzcpEP4U0smAew8U+kXCAsRcojAYiNl+iTt0hKS60oRHRk8SSKsF3k60/9JG6dQlKhKh0RhUHHarjzADvK3zhVSZFXqiKuLK2jpLdYyGs991oB6FJ44G3+hVtSNeulzL5dPfpfmsGwt3gPGMyAUL6PPIg7Y2qVFMhreIy7AojoHeRbU2SrHzKBxV/rUW8IF1jAUk92AX16MMdKO9LhUcPYEb3AsXS3JuPr5+LbbvJN1lTrb0LB++ITaU3ZLqTHq7zdYD1bLmDbwXGRxpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 27e6a24a4cf3 ("mm, virt: merge AS_UNMOVABLE and AS_INACCESSIBLE")
folded the two flags into one, on the grounds that guest_memfd was the
only user and always set both. But the two flags were added for
different reasons and guard different things:

  AS_UNMOVABLE (0003e2a41468) marks a mapping whose folios cannot be
  migrated.

  AS_INACCESSIBLE (c72ceafbd12c) marks a mapping whose contents must
  not be directly R/W accessed. Its only job is to stop
  truncate_inode_partial_folio() from zeroing the folio.

The merge assumed unmovable and inaccessible were the same thing.
This cannot express a mapping that is inaccessible yet still movable,
which is exactly what guest_memfd wants.

Reintroduce AS_UNMOVABLE and restore the original split: truncate keeps
checking AS_INACCESSIBLE, while migration and compaction go back to
checking AS_UNMOVABLE.

Currently guest_memfd sets both, so the resulting flags and behaviour
are unchanged. Preparatory change to support folio migration for
non-confidential guest_memfd VMs.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/pagemap.h | 24 ++++++++++++++++++++----
 mm/compaction.c         | 12 ++++++------
 mm/migrate.c            |  2 +-
 virt/kvm/guest_memfd.c  |  1 +
 4 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..a7dcaa66e4e3 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_UNMOVABLE = 11,	/* The mapping cannot be moved, ever */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -322,11 +323,10 @@ static inline void mapping_clear_stable_writes(struct address_space *mapping)
 static inline void mapping_set_inaccessible(struct address_space *mapping)
 {
 	/*
-	 * It's expected inaccessible mappings are also unevictable. Compaction
-	 * migrate scanner (isolate_migratepages_block()) relies on this to
-	 * reduce page locking.
+	 * The mapping's contents must not be accessed by the CPU through
+	 * the kernel direct map or other internal paths (e.g. zeroing of
+	 * pages during truncation).
 	 */
-	set_bit(AS_UNEVICTABLE, &mapping->flags);
 	set_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
@@ -335,6 +335,22 @@ static inline bool mapping_inaccessible(const struct address_space *mapping)
 	return test_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
+static inline void mapping_set_unmovable(struct address_space *mapping)
+{
+	/*
+	 * It's expected unmovable mappings are also unevictable. Compaction
+	 * migrate scanner (isolate_migratepages_block()) relies on this to
+	 * reduce page locking.
+	 */
+	set_bit(AS_UNEVICTABLE, &mapping->flags);
+	set_bit(AS_UNMOVABLE, &mapping->flags);
+}
+
+static inline bool mapping_unmovable(const struct address_space *mapping)
+{
+	return test_bit(AS_UNMOVABLE, &mapping->flags);
+}
+
 static inline void mapping_set_writeback_may_deadlock_on_reclaim(struct address_space *mapping)
 {
 	set_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
diff --git a/mm/compaction.c b/mm/compaction.c
index f08765ade014..e6b0fdfaf79d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1133,22 +1133,22 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (((mode & ISOLATE_ASYNC_MIGRATE) && is_dirty) ||
 		    (mapping && is_unevictable)) {
 			bool migrate_dirty = true;
-			bool is_inaccessible;
+			bool is_unmovable;
 
 			/*
 			 * Only folios without mappings or that have
 			 * a ->migrate_folio callback are possible to migrate
 			 * without blocking.
 			 *
-			 * Folios from inaccessible mappings are not migratable.
+			 * Folios from unmovable mappings are not migratable.
 			 *
 			 * However, we can be racing with truncation, which can
 			 * free the mapping that we need to check. Truncation
 			 * holds the folio lock until after the folio is removed
 			 * from the page so holding it ourselves is sufficient.
 			 *
-			 * To avoid locking the folio just to check inaccessible,
-			 * assume every inaccessible folio is also unevictable,
+			 * To avoid locking the folio just to check unmovable,
+			 * assume every unmovable folio is also unevictable,
 			 * which is a cheaper test.  If our assumption goes
 			 * wrong, it's not a correctness bug, just potentially
 			 * wasted cycles.
@@ -1161,9 +1161,9 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 				migrate_dirty = !mapping ||
 						mapping->a_ops->migrate_folio;
 			}
-			is_inaccessible = mapping && mapping_inaccessible(mapping);
+			is_unmovable = mapping && mapping_unmovable(mapping);
 			folio_unlock(folio);
-			if (!migrate_dirty || is_inaccessible)
+			if (!migrate_dirty || is_unmovable)
 				goto isolate_fail_put;
 		}
 
diff --git a/mm/migrate.c b/mm/migrate.c
index dd15a84b2a52..d4dcd7f142ce 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1101,7 +1101,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 
 	if (!mapping)
 		rc = migrate_folio(mapping, dst, src, mode);
-	else if (mapping_inaccessible(mapping))
+	else if (mapping_unmovable(mapping))
 		rc = -EOPNOTSUPP;
 	else if (mapping->a_ops->migrate_folio)
 		/*
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 45cbdf4801ec..169f75f95433 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -593,6 +593,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	inode->i_size = size;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
 	mapping_set_inaccessible(inode->i_mapping);
+	mapping_set_unmovable(inode->i_mapping);
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 

-- 
2.43.0


