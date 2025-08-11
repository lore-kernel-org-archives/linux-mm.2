Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BF7CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C058E0020; Mon, 11 Aug 2025 05:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3C68E000A; Mon, 11 Aug 2025 05:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AB208E0020; Mon, 11 Aug 2025 05:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23BEF8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:10:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D82F5140750
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:10:03 +0000 (UTC)
X-FDA: 83763904686.17.6F850A0
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	by imf12.hostedemail.com (Postfix) with ESMTP id F244B40008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:10:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="cCQ3ND/B";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.107.92.76 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754903401; a=rsa-sha256;
	cv=pass;
	b=eBeX2YO+W+12/nZZBP2etgl3lqGLjCjVZthmufA8+pNHfdKmuAEgmVYMQ1Y/E85wyYLqfP
	htLhPcl0+R/C4NrO2fOwPqcAkp0J5cpvdyazLy/OlvuuwqZNaKjOmcjfghYDTgbXAkDbNE
	jpYm9EnAx8lAxKgI9Gnqucz6oyMXuuM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="cCQ3ND/B";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 40.107.92.76 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754903401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPDfLyt/MPaUAMCoHLY3T7BwEtSKTurKhRPa+CQpITI=;
	b=N0rCDSI71/KsuuPrA+UZLu6sIaaTM+ofer+Jb9wtXJHT4+hjZvJOz+BqoYF9keEHmfgmD6
	5J1gbnwKi5mHPbxfp6SXxdLsF+KD7w+Cy22HHxR8Fg2PVdruuoLw8GDqYSFhG0Q52flVPq
	YQvC/hLTq+l0RrrzFMTQB0vDn/WAaqk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aDWDRtYSOJaFP96DlX8ZpH6KExqhlEIXbNlXFf8sqMIxFXWCd9VqDR0UEkBM7e3J+MF56ibHt++FrdUHacgEkppF025DuD20LL68Fdy/fPGibgTpnX5ZWcwbY13BmRgx/Y1xwjW4bGwfysgPZuSAq5+66OETLeaarNWEdJLNPLUOBeMBLps1pOggJZJsXIwuc5u1R/+ehk1oma3wUUWO26LOgf+RKfeWIXs2X3SCI9CNzjd3mCLab/u5/5bAQCZGX7IWoPMVu8412eL62am+Cb4RfEfA/OMB0kqg0vG2xM8yEUCfe91PthsqNXHwolCMpkOJyRb+i4/rpaustvB2QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPDfLyt/MPaUAMCoHLY3T7BwEtSKTurKhRPa+CQpITI=;
 b=n5qj+/iLpWJ51qyAjFRSZu1mkjciTnFImOWXUDzT6Nd0OVmjv/s54wvoQjhH67BhMWRID1msyjJCD+NF4uBqxgai97qkkeOP0Ik0Ky7iu5Ir8e6Q6ruvXdDKZo15DUsmJBptteex4fKIbY94woyyoc8Q6mZ6n1YtTrgGspCtjnlorSZpIEoGGWNGPW07XCzM19XI0VbeCTXSpPVxj7RcgLHyuuVzV2l8Q3IcWlKhmFWnxV1hDa+qUxxpSOs1w8BXjymBAKHDGoNe2GGPgcGvm7PPV1/T1CbNLqCuDbKMAo1IQE8XQqpLNRoQYimC8LggVdRiwdUN/nUlF7Q0xxt2WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPDfLyt/MPaUAMCoHLY3T7BwEtSKTurKhRPa+CQpITI=;
 b=cCQ3ND/BY6BuPE/cZ2JSFTmGQ8HCYkRtmSdzWmyoGCZLdRZ4vHxePDJBxpGh5TZ+1FQJPWKmotOf9pFG1sZB8s6H33Qej2HoqQ6Ld/UrD2cFTRzveohwkRXx3/E1s6S43u7OFguZzH2RQjXnffp1tnCgDYpwHtD0qgV25myzBUA=
Received: from MN2PR12CA0027.namprd12.prod.outlook.com (2603:10b6:208:a8::40)
 by CH3PR12MB7498.namprd12.prod.outlook.com (2603:10b6:610:143::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 09:09:57 +0000
Received: from BL02EPF00021F6A.namprd02.prod.outlook.com
 (2603:10b6:208:a8:cafe::7a) by MN2PR12CA0027.outlook.office365.com
 (2603:10b6:208:a8::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.21 via Frontend Transport; Mon,
 11 Aug 2025 09:09:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6A.mail.protection.outlook.com (10.167.249.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:09:56 +0000
Received: from kaveri.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:09:41 -0500
From: Shivank Garg <shivankg@amd.com>
To: <seanjc@google.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<willy@infradead.org>, <akpm@linux-foundation.org>, <shuah@kernel.org>,
	<pbonzini@redhat.com>, <brauner@kernel.org>, <viro@zeniv.linux.org.uk>
CC: <ackerleytng@google.com>, <paul@paul-moore.com>, <jmorris@namei.org>,
	<serge@hallyn.com>, <pvorel@suse.cz>, <bfoster@redhat.com>,
	<tabba@google.com>, <vannapurve@google.com>, <chao.gao@intel.com>,
	<bharata@amd.com>, <nikunj@amd.com>, <michael.day@amd.com>,
	<shdhiman@amd.com>, <yan.y.zhao@intel.com>, <Neeraj.Upadhyay@amd.com>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <aik@amd.com>,
	<jgg@nvidia.com>, <kalyazin@amazon.com>, <peterx@redhat.com>,
	<shivankg@amd.com>, <jack@suse.cz>, <rppt@kernel.org>, <hch@infradead.org>,
	<cgzones@googlemail.com>, <ira.weiny@intel.com>, <rientjes@google.com>,
	<roypat@amazon.co.uk>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <kent.overstreet@linux.dev>,
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<chao.p.peng@intel.com>, <amit@infradead.org>, <ddutile@redhat.com>,
	<dan.j.williams@intel.com>, <ashish.kalra@amd.com>, <gshan@redhat.com>,
	<jgowans@amazon.com>, <pankaj.gupta@amd.com>, <papaluri@amd.com>,
	<yuzhao@google.com>, <suzuki.poulose@arm.com>, <quic_eberman@quicinc.com>,
	<aneeshkumar.kizhakeveetil@arm.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-security-module@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH RFC V10 7/7] KVM: guest_memfd: selftests: Add tests for mmap and NUMA policy support
Date: Mon, 11 Aug 2025 09:06:09 +0000
Message-ID: <20250811090605.16057-13-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250811090605.16057-2-shivankg@amd.com>
References: <20250811090605.16057-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6A:EE_|CH3PR12MB7498:EE_
X-MS-Office365-Filtering-Correlation-Id: 31473fa7-8bfe-4f6a-a4fb-08ddd8b6d7a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vjLIh5qPZ3GZBc1s5AAtnvzkJda+p+9yLObiZUQvf5SwPLtWpia5mK7+9PoE?=
 =?us-ascii?Q?QiU+ryVS8mnQa32iyqVXxc7fMMWnT+F4maZJKqK69l9ps0gfGIyB+yXflBLp?=
 =?us-ascii?Q?CotUoWI07qutKZUEYBf1jEF9RvQ0BpeEqemFNPR+q3vOMPpwBlphH84qJ+dX?=
 =?us-ascii?Q?U0QfdPR+aSUgZLWMJoiTPSIiMH1FF7H31w9YxFbPDOf3YkSoRTpUTmIXlxns?=
 =?us-ascii?Q?BKlzPbjKA7ymFnZA3TzplTR6EObtMl2maUGtjnduwNXdL+2aR4c817h51t4N?=
 =?us-ascii?Q?yy9qT48T0jMI5QAE2KrRIroGIQNoFvfHKqjFk1NxOwlTwSZplAXVyW65l8bK?=
 =?us-ascii?Q?fg/9XopPj80hQvLYrEqZ47Vn9ywHHpQ1yfl/gv5JExDu2cEgvU3rUVaShwy9?=
 =?us-ascii?Q?k4UGmbgN2J1QmwIkwygQFonX58ZqsQp/sEBQgaBtjCe93CYHKLeNg2++/Jjr?=
 =?us-ascii?Q?cpfXi0jzUj87wGr2g01cM+3fRolxSP9xCM5+HZp4t/Pfa3u7cG0DxSkOlrnD?=
 =?us-ascii?Q?OBymW44LlaQdhKBiliFlvYAj51atPhJpfI6kL/vAR4x/RnNVaYVgY1fFHlOt?=
 =?us-ascii?Q?gYbQxBM6JXnPc0OLhGcts5irhCtL8Ia9Hz84kR+/7jYiESCJTFWUKOmkA83g?=
 =?us-ascii?Q?jguJdUEvyJjFfpGVlhU90csI/62uvJUEPq6TwZgMX2UIz0culJb9udiDoymn?=
 =?us-ascii?Q?O51fHjKjR3n+qhykVv8R9cMJgx2G5TfduGjEw10I+zxi5k2mUoSEj+dnmvff?=
 =?us-ascii?Q?Tm6YNaMFgJhSHsynQQoasEfnyl/3Ah99G+BYfuaRVFPnbei0eFL2QVHtP76a?=
 =?us-ascii?Q?fuTfCjxZOm5uj/+5XU+eoHAnVEYgLDdg71o2OaGLr+pai0apFvEKycCmsYQK?=
 =?us-ascii?Q?MnVT6Rx/QLDjXtosuXZn4ckIzusCRH0tqHXqp3i7glY/x2InzOmxuyNuNu/3?=
 =?us-ascii?Q?XxzqzPLf9jsUZs9fCUrX+1UjUgMtfPY968IP1lNw6oUFLgX4y2wGoy0Jur9c?=
 =?us-ascii?Q?hmdRH7Uo7G5NL4nmRqt93rLQFdVgG4080w6P0naNyZCaiH90VFWLhQdhWT9U?=
 =?us-ascii?Q?8WtDK1zf7yWkjnP0L2/pUo3M5Ugx+N5WWN5dXHZbYZACEr75/H671yVTO6i6?=
 =?us-ascii?Q?+XgBnFv9HW3o7ZFrcBYi3wlxpUwsf/nSvh1FwdRW4UrcSY06s/Qyk+9kqJwU?=
 =?us-ascii?Q?+0Kk45fZb/7k57wNln4tY6AbMWYFEO+65t+ikvuH7YFTs2lUKNudvGDiEdjx?=
 =?us-ascii?Q?nnKRoz8sh/IXdmcOSbQXCnOP9CL1VI+oiOlqRkg/hBT1m1RVWHM2t/w+Vn2S?=
 =?us-ascii?Q?0IYc3htSwerbERLVgUj4og3+1QaWoLR2UJvlsQCs1+N4TaC5M21zUsBzqArU?=
 =?us-ascii?Q?Qgihd7eBcYmxiM3Iowzt8V1mW+/tQYzr6HqlvnORtW/nwm2qZzl2Db+uZpPV?=
 =?us-ascii?Q?//Ll4hkv3fVWvdm//5Bov3CoK7lnwXlcYmEhsuW+rDpRBMMUJTfU3NAwFkHR?=
 =?us-ascii?Q?v8l7DdiNZ89l1NvWKmq+H1dc3rNp+7HChAr3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:09:56.9302
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31473fa7-8bfe-4f6a-a4fb-08ddd8b6d7a0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7498
X-Stat-Signature: mhh7x1swec1hxbqcrietcworihontqry
X-Rspam-User: 
X-Rspamd-Queue-Id: F244B40008
X-Rspamd-Server: rspam02
X-HE-Tag: 1754903400-408416
X-HE-Meta: U2FsdGVkX1+7lvCldYuKX8AlW9k99oFQ+f/x/roB5BS+rJ9IhrRAGyiAasaztnZ5y0PO7stqprHrYtIo0McsA+CPhQ0IEZqJCo01+arm/rQoI+Q9Yufk6xUm+p595ZY+i8BZtbvxlB0k5ewdEMadw7OayC2d+aOVjScA2FTOU9XFcOIt0td560x9kEju4DzKM/6+QIiMv/YwBchqx3IAJpzXFpx2C+YOK61L1gFw/LDpSNG+rFkjjQoBMEzHTrw9edLWW023mlPcrum5l424pi9dOvz8VHrRfm9ofRzFETqK+hPh6WbcnFb3QtdgjIt8OqSEk+mi9aB9TOkNIBCo/5pcv0CILEHj7NedPJ4g57JgLL5sxIl6LHQRp5rPJoRKMhQ+EBz18wrKqpZej2tXlAlbdZNOYxZrHhWPnmbag7ifmdWQj4YD9qLHziiaY6TeziiwvSEAoMjdxs+ev9YwUUpZy6Gig6HJ2Q1b0tDANJ2kKO3CvCwK8w3zIwbbZfdyKkKETd/tnniiIVdtPBrwiw748Kr3liwAwDYD0VaFR0WENdydaJYC0vzH36IwiWoqzjEIEkmZ4whnWOC7qbYpLMWuTErgdFFMQWmk1zFa3QXt4pUB38Cd6X8ZHIuvmEDgMdynuLhkvHqR0nqEO55GYwZKVuZ6B6KdwIijmbWQupC5O17/dgprBSd5/8gg6qrpG/J9OIMspmkIgVpBnyrdPA6VmcNWLrc8hPOE0RF33FnIcL541mZ2GopOi6MOmAF3R1Wesc4AeQfH1BKCUyV0+YQKpoezwcz4PfyXioEBH6j4U67ju0XchcsRQ2DIF+dGlwChRm/zxB3W/HQe+/rMKnfQTXkpm+xBZjiP9/LBZl5Ho3eUKxLUkTtk4x6TAN371ru6FPnEdkVw/Vq/jbunt7Pxxw7mhHb6XOyz5JnttIt7BB3o8j+3rqE4Mzn+ojkDD11KHkEtOrv/YqpsS1p
 BQMIDSmN
 t7EKg/dOWnWfxsfT6dUzGGJ8aRyZ3KhTr9l5sKSW7VVrsJ7HFI90fZT6ic6iZhql8hIkvy6lgESnkBN/eMRjou50zBbmC1OR9yJz+ZS4oif6psTjF6Zefdq03nwaq4SemUDBasQZO5+g9eMbWGofySkkMUYx+NcJrjSEqxQvKOZdu8/XErEWCd4yzhkfrag7iiAjE8mTvGJ24ca97/50QrVPUUzr0gNXSSmskLOKXXdwjrIxF0XSNGKEGnzNfJdkovl5WA+Huk0t8Hx335pBSLJF6AjYTxqNwXJZCtKLY0EM4xu/m7tH5dzIuhWXTInBgSDy5Hs8XcDDdfaPj5Cdkx9NKNnkJe07eAFF0c++hVMrT5cO9DqVwirSwMDt+lEZgFwJedkeDuTIIKZ9gQ4YrZH6n04Mgkw/4EEC/DrpvbdmCTgJF8XmwL69o3gclITLWNKu7yuQ8+/nMs0VXlwGP1EmgxvEqMpSEd0f+pnMwy8crXhCj8vaDWL539pTg4g2MTrMpTiw3ASA4ok/H4QWD+KV7nYyI9VprpK6yBjWkpRFzRWpfDF65EHbr+ijouuvM+AiSbviVTLI8t5OVyccSktJoR2hasLhaLXNfEX41vwXK63mpp5FfqDY5W7WCa70M8Y60/Wsai6jD295F6o45SGHKS1JhQpKcxWPGHL1QrQtlv7wb5ZyyKSpKWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add tests for NUMA memory policy binding and NUMA aware allocation in
guest_memfd. This extends the existing selftests by adding proper
validation for:
- KVM GMEM set_policy and get_policy() vm_ops functionality using
  mbind() and get_mempolicy()
- NUMA policy application before and after memory allocation

These tests help ensure NUMA support for guest_memfd works correctly.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 121 ++++++++++++++++++
 2 files changed, 122 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 90f03f00cb04..c46cef2a7cd7 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -275,6 +275,7 @@ pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
 	$(CC) -Werror -Wl$(comma)--s390-pgste -x c - -o "$$TMP",-Wl$(comma)--s390-pgste)
 
 LDLIBS += -ldl
+LDLIBS += -lnuma
 LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
 
 LIBKVM_C := $(filter %.c,$(LIBKVM))
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index b86bf89a71e0..4d33c225d9f7 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -7,6 +7,8 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <numa.h>
+#include <numaif.h>
 #include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
@@ -19,6 +21,7 @@
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/syscall.h>
 
 #include "kvm_util.h"
 #include "test_util.h"
@@ -72,6 +75,122 @@ static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
 	TEST_ASSERT(!ret, "munmap() should succeed.");
 }
 
+#define TEST_REQUIRE_NUMA_MULTIPLE_NODES()	\
+	TEST_REQUIRE(numa_available() != -1 && numa_max_node() >= 1)
+
+static void test_mbind(int fd, size_t page_size, size_t total_size)
+{
+	unsigned long nodemask = 1; /* nid: 0 */
+	unsigned long maxnode = 8;
+	unsigned long get_nodemask;
+	int get_policy;
+	char *mem;
+	int ret;
+
+	TEST_REQUIRE_NUMA_MULTIPLE_NODES();
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap for mbind test should succeed");
+
+	/* Test MPOL_INTERLEAVE policy */
+	ret = syscall(__NR_mbind, mem, page_size * 2, MPOL_INTERLEAVE,
+		      &nodemask, maxnode, 0);
+	TEST_ASSERT(!ret, "mbind with INTERLEAVE to node 0 should succeed");
+	ret = syscall(__NR_get_mempolicy, &get_policy, &get_nodemask,
+		      maxnode, mem, MPOL_F_ADDR);
+	TEST_ASSERT(!ret && get_policy == MPOL_INTERLEAVE && get_nodemask == nodemask,
+		    "Policy should be MPOL_INTERLEAVE and nodes match");
+
+	/* Test basic MPOL_BIND policy */
+	ret = syscall(__NR_mbind, mem + page_size * 2, page_size * 2, MPOL_BIND,
+		      &nodemask, maxnode, 0);
+	TEST_ASSERT(!ret, "mbind with MPOL_BIND to node 0 should succeed");
+	ret = syscall(__NR_get_mempolicy, &get_policy, &get_nodemask,
+		      maxnode, mem + page_size * 2, MPOL_F_ADDR);
+	TEST_ASSERT(!ret && get_policy == MPOL_BIND && get_nodemask == nodemask,
+		    "Policy should be MPOL_BIND and nodes match");
+
+	/* Test MPOL_DEFAULT policy */
+	ret = syscall(__NR_mbind, mem, total_size, MPOL_DEFAULT, NULL, 0, 0);
+	TEST_ASSERT(!ret, "mbind with MPOL_DEFAULT should succeed");
+	ret = syscall(__NR_get_mempolicy, &get_policy, &get_nodemask,
+		      maxnode, mem, MPOL_F_ADDR);
+	TEST_ASSERT(!ret && get_policy == MPOL_DEFAULT && get_nodemask == 0,
+		    "Policy should be MPOL_DEFAULT and nodes zero");
+
+	/* Test with invalid policy */
+	ret = syscall(__NR_mbind, mem, page_size, 999, &nodemask, maxnode, 0);
+	TEST_ASSERT(ret == -1 && errno == EINVAL,
+		    "mbind with invalid policy should fail with EINVAL");
+
+	TEST_ASSERT(munmap(mem, total_size) == 0, "munmap should succeed");
+}
+
+static void test_numa_allocation(int fd, size_t page_size, size_t total_size)
+{
+	unsigned long node0_mask = 1;  /* Node 0 */
+	unsigned long node1_mask = 2;  /* Node 1 */
+	unsigned long maxnode = 8;
+	void *pages[4];
+	int status[4];
+	char *mem;
+	int ret, i;
+
+	TEST_REQUIRE_NUMA_MULTIPLE_NODES();
+
+	/* Clean slate: deallocate all file space, if any */
+	ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, total_size);
+	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) should succeed");
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should succeed");
+
+	for (i = 0; i < 4; i++)
+		pages[i] = (char *)mem + page_size * i;
+
+	/* Set NUMA policy after allocation */
+	memset(mem, 0xaa, page_size);
+	ret = syscall(__NR_mbind, pages[0], page_size, MPOL_BIND, &node0_mask, maxnode, 0);
+	TEST_ASSERT(!ret, "mbind after allocation page 0 to node 0 should succeed");
+	ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, page_size);
+	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) should succeed");
+
+	/* Set NUMA policy before allocation */
+	ret = syscall(__NR_mbind, pages[0], page_size * 2, MPOL_BIND, &node1_mask, maxnode, 0);
+	TEST_ASSERT(!ret, "mbind page 0, 1 to node 1 should succeed");
+	ret = syscall(__NR_mbind, pages[2], page_size * 2, MPOL_BIND, &node0_mask, maxnode, 0);
+	TEST_ASSERT(!ret, "mbind page 2, 3 to node 0 should succeed");
+	memset(mem, 0xaa, total_size);
+
+	/* Validate if pages are allocated on specified NUMA nodes */
+	ret = syscall(__NR_move_pages, 0, 4, pages, NULL, status, 0);
+	TEST_ASSERT(ret >= 0, "move_pages should succeed for status check");
+	TEST_ASSERT(status[0] == 1, "Page 0 should be allocated on node 1");
+	TEST_ASSERT(status[1] == 1, "Page 1 should be allocated on node 1");
+	TEST_ASSERT(status[2] == 0, "Page 2 should be allocated on node 0");
+	TEST_ASSERT(status[3] == 0, "Page 3 should be allocated on node 0");
+
+	/* Punch hole for all pages */
+	ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, total_size);
+	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) should succeed");
+
+	/* Change NUMA policy nodes and reallocate */
+	ret = syscall(__NR_mbind, pages[0], page_size * 2, MPOL_BIND, &node0_mask, maxnode, 0);
+	TEST_ASSERT(!ret, "mbind page 0, 1 to node 0 should succeed");
+	ret = syscall(__NR_mbind, pages[2], page_size * 2, MPOL_BIND, &node1_mask, maxnode, 0);
+	TEST_ASSERT(!ret, "mbind page 2, 3 to node 1 should succeed");
+	memset(mem, 0xaa, total_size);
+
+	ret = syscall(__NR_move_pages, 0, 4, pages, NULL, status, 0);
+	TEST_ASSERT(ret >= 0, "move_pages should succeed after reallocation");
+	TEST_ASSERT(status[0] == 0, "Page 0 should be allocated on node 0");
+	TEST_ASSERT(status[1] == 0, "Page 1 should be allocated on node 0");
+	TEST_ASSERT(status[2] == 1, "Page 2 should be allocated on node 1");
+	TEST_ASSERT(status[3] == 1, "Page 3 should be allocated on node 1");
+
+	TEST_ASSERT(munmap(mem, total_size) == 0, "munmap should succeed");
+}
+
 static sigjmp_buf jmpbuf;
 void fault_sigbus_handler(int signum)
 {
@@ -286,6 +405,8 @@ static void test_guest_memfd(unsigned long vm_type)
 	if (flags & GUEST_MEMFD_FLAG_MMAP) {
 		test_mmap_supported(fd, page_size, total_size);
 		test_fault_overflow(fd, page_size, total_size);
+		test_mbind(fd, page_size, total_size);
+		test_numa_allocation(fd, page_size, total_size);
 	} else {
 		test_mmap_not_supported(fd, page_size, total_size);
 	}
-- 
2.43.0


