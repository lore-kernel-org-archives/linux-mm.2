Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34404E7DF0A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A486B00BF; Mon,  2 Feb 2026 12:02:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4D66B00C0; Mon,  2 Feb 2026 12:02:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C97A6B00C2; Mon,  2 Feb 2026 12:02:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 488BA6B00BF
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:02:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BA5B13A007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:02:51 +0000 (UTC)
X-FDA: 84400136142.17.976C3D8
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013017.outbound.protection.outlook.com [40.93.201.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id 41CA7C000A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:02:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=QxygLPEf;
	spf=pass (imf28.hostedemail.com: domain of Benjamin.Cheatham@amd.com designates 40.93.201.17 as permitted sender) smtp.mailfrom=Benjamin.Cheatham@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770051768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZS3wNG1ZQrNPgkiWVP7CWSgc1UurS5y2H0Vo1LQEZrs=;
	b=Lc8zxkbHUc453+be+/6AkA0sUBHxrtFIedGMLEjqnA5FTpxudcZhnL7UpGLCuc8cTu46DM
	w8B3GajAg5q4h6dQtHRqbgMPozKKfg3XDPNY2CDucO4zvtZsXSnfkttS+TzSNCmMp2QuUu
	i1ItpSda7/e0Cwd8aYliO/+IikcHCDQ=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=QxygLPEf;
	spf=pass (imf28.hostedemail.com: domain of Benjamin.Cheatham@amd.com designates 40.93.201.17 as permitted sender) smtp.mailfrom=Benjamin.Cheatham@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770051768; a=rsa-sha256;
	cv=pass;
	b=ai06T0QYyyVJGJyLGoOZbft7kwii5BPbUw8DtC7KuHZGooe5SK2uCNXUxK0RMszOxshxIT
	EQAXXNBcn3RaXynPz9zFYtPABGbUow4ULYaaBKccQHd4PmoEYAU1oXtQc6ZIhU6C8JbZ7q
	wolZEcRZ6C5kdl5j3JGV/nPEnTISYVw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cq/iM1g1wg1rqiMoKEGEjB6AzrwG+n2ZanMSLHEu5D+XkouikfH6Aht3jULJoRbcKT5g5gpx70w1JdzJXUtKRktsEsSWlINzuBBHzAudrgWIuGmtbERbh9fv71YhAseq2URrKWpHd+8pKeWpP+Bf1xYbwORMhiyOCUispi84MUHwDLTZEJr7u8hA2+3N54cwkbodBvXFYXlDttSKay9e+RYj1K2iSVJcJv+eEOEkYGddX2yLwMP/tUJVxyeC1ab6UBzz30Wb6y2dzux0xpK7kNu8noyjZd0I7hmsHZYDSEazdBH0Gx+NcZBJCVknjH2mJjIuJ8sg7/F5ZfzTF4qDzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZS3wNG1ZQrNPgkiWVP7CWSgc1UurS5y2H0Vo1LQEZrs=;
 b=BFThIP9CFOapv28LrmNaYl7MD6AsMRcYgPH4wJ+Ip5zPMVeladse92JzyaRPG54xbePDygB0FztkaTVnzeZ7VV/nr53rOn3rg0ldDhaYJWWC7gYAKz4BHh2f0YZTvkVgNFci+ZyfmBkqGkvO92TitKRyxIhntcpGKD4hdWhyXyQsFL+h3RQuiy888bR2nNLmqUAlnmtQ2zTWgg4g2aok1ghly/yY9Em/h3zun3M+L7Bkio4EUuk0TXFU7776IWKP5tZKlBNgLfm9ayWtUtm1RG3c8KtUGZzlQhZP9ZbO2KcLH/9u3JWMyq/TlrhtTiH4MGocoivgyX6Zo443q5mBSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gourry.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZS3wNG1ZQrNPgkiWVP7CWSgc1UurS5y2H0Vo1LQEZrs=;
 b=QxygLPEf+Y6DOQ9bKI39D0hhwnpU6zm9aAZ+wrSxImddBHB5jP3lAi4sqk69CTdsC6qk/I4rPu6zfRtb1pkFD/DLcZsyWvTIPsoC72ou7RB9tHFz9A9Crmxqcwi7MQa4gdOOcd8tNzq6Mo06F2S/qzN20NSntR5vUZiGh0F8JqE=
Received: from BN0PR04CA0173.namprd04.prod.outlook.com (2603:10b6:408:eb::28)
 by PH7PR12MB8123.namprd12.prod.outlook.com (2603:10b6:510:2bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 17:02:42 +0000
Received: from BN1PEPF00006000.namprd05.prod.outlook.com
 (2603:10b6:408:eb:cafe::c0) by BN0PR04CA0173.outlook.office365.com
 (2603:10b6:408:eb::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.16 via Frontend Transport; Mon,
 2 Feb 2026 17:02:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN1PEPF00006000.mail.protection.outlook.com (10.167.243.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Mon, 2 Feb 2026 17:02:41 +0000
Received: from [10.254.59.95] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 2 Feb
 2026 11:02:39 -0600
Message-ID: <9652a424-6eb1-462f-8cbd-181af880f98b@amd.com>
Date: Mon, 2 Feb 2026 11:02:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] cxl/core: Add dax_kmem_region and sysram_region
 drivers
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<kernel-team@meta.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<dan.j.williams@intel.com>, <willy@infradead.org>, <jack@suse.cz>,
	<terry.bowman@amd.com>, <john@jagalactic.com>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-9-gourry@gourry.net>
 <c1d7d137-b7c2-4713-8ca4-33b6bc2bea2b@amd.com>
 <aX0s4i5OqFhHkEUp@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <aX0s4i5OqFhHkEUp@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb08.amd.com
 (10.181.42.217)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006000:EE_|PH7PR12MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: 0da34349-4baa-4f6a-27a6-08de627ce0ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700013|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHVQcGM1blNWWEl0dFJuVW5PVGtyVDViRHNSTzNyK0RacCt1bUVHcjBtUEtz?=
 =?utf-8?B?d0RBNVlRWFNTcVg3cU5qTVQzV29BelY3c1Rsd3BoTjdSNFRRbWYyUHVhK0xY?=
 =?utf-8?B?S3RIRzduZ2Q4aWlaTWdaTnRLVDc3SkRsTGJYM1NQVmtTbi9yakdwS3NmU0J0?=
 =?utf-8?B?RnArMlJVcHpMU0FXMHhLTC9ZK1VkNXVLanVkZyt5VG9zdFltZ0JDaUJTV3oz?=
 =?utf-8?B?S0FFKzA2U1dMdjFqU2YzMk96Wi84VGQydFdaU2ZmcUVtL0RTWnBXeHlFV2Z2?=
 =?utf-8?B?RTQzWkY3ZHVNZlZ2SWJ5V2o5dzMwYlMzQ09JTW1INTFYbGt3WGZyM1F3aXAx?=
 =?utf-8?B?d0ZUU0FaNHNPaGN6bDdpWXNtNC9RRDZnbmRBZTRISzBPZTducnVYMWM4N1ZE?=
 =?utf-8?B?a0d3QU90VzRHMjNXT2hJREh1M0tHQjRleHZZYlUxTSs2V3ZyVVZCSGxOQjJx?=
 =?utf-8?B?aU1zVFBxUSttNlNzV0NHS202MTJqMUoxdVl0d3o5eDVNTU4xRGFCc3VsVEJJ?=
 =?utf-8?B?ZFhaeHFVcHg1ZUg0em9jTm4yUzVvZ2tSMzZCV3ErU2dtZzhndzA0MUZPWmt6?=
 =?utf-8?B?N2RUNDA2bHhWd3hZWTJnK0YyZ2NDcmdCQTl5b29JVzB2UmZ5eUdJcDJmT2wr?=
 =?utf-8?B?QUpOdDRnbjVkTHg5UnVEbllDeEJLaVZyTFR3YXNxZ1dvdytPckNXdnlCUi9x?=
 =?utf-8?B?dVdDSmdXU2gyWTV0dGJKdFkybUZlUlpKajllTUtiMktiRWl3OGRnaXVEUDFM?=
 =?utf-8?B?aUVCNGZWbzFISVNKVEd5aDRyL0pBS3dqREo2dDVLZk5xSDlETTQxaWFWSlNM?=
 =?utf-8?B?VmJsYi9CR2FmRVVtbEZmbU1zQ1I4MDJ6YytoNmpxeHpMb3VxTWtUZWJFYTZa?=
 =?utf-8?B?S1hZS0FPRzh6V0UyYkZkVU12QzZFN21POWZ4L3E1cnVVQXZ5K1hMdlVTWWJa?=
 =?utf-8?B?dnNDZFdoZmoyQXNlTjM5a01IQnVkM1d6akw3emQwMm9qMFFlRzQrWFlTNFdk?=
 =?utf-8?B?d0lkM3lzdFJYa2dWREx3a3doTDhtNmo0dUdhdHl4aDFZdjRrVmlMQlZ2cndF?=
 =?utf-8?B?SzlVMEVHekZwVDI3akRhN25SMVl2SStrR2RJOU92clFTZjNWc0JmdmFoaEpm?=
 =?utf-8?B?dW55RkJxMnZOMUNVUWQzKzhuMnhyUHVDMUdmbWdzZHpyL2hjRFdFd0U3ek1F?=
 =?utf-8?B?RTEzWEMyU0dkOFRYYWMvUDh5SlRrK1U1b24wRUU0bG1rNDBxV2FudUpmOTJn?=
 =?utf-8?B?YkdCSmxaR1FSOFRkcGFMdm5xeGxXejVIZDVHSk5zb3pjTkNVcU9IcGw4cmVt?=
 =?utf-8?B?YTBFSHRHSnFMWDhncEZDaTVyWXpCUzhBNTdEeG04M3hqYXlqc0dmSzVIMk5F?=
 =?utf-8?B?bXlObkY1alZJbk15enl2eHRvWW9RSkREQUZGQW9rd2J4bWNkR2J5WExpa01t?=
 =?utf-8?B?YlJrSzg3T3Q5T3dSY0RCaHN3M1Z6cW5waHYzK05qZ2xxbGFQN2d1YnhKbU94?=
 =?utf-8?B?VzlpSktCd2VGTFkybVlLNEFFVVlYU3EvREY3ZjUycFJQdXVaWlBydU00QnVE?=
 =?utf-8?B?c3J3aENTVkFYdzhGRVRzVGcremoybEFKWmo2cWhPWEpPdUVVK0poRm9XSkI2?=
 =?utf-8?B?dlRHRUF3TGFjdXAyK2pZTVIyYTljaXB6bWRlenN4SnhvM1M3dGx5U3pMMCt5?=
 =?utf-8?B?WURoZkxCTzlYdy9SNC9VUS90OWFucE1kWWhYY3NaSFgrSVoyUVdlWHFKYWk4?=
 =?utf-8?B?ZTdVdmF0K2t2dFg2ZWZueEN6Vm1GR0pndDBkVk1qRWJHZUpwQmlyNXptaGk4?=
 =?utf-8?B?ZjRWU2pZeFhrN2JqaERJeGJzR0crK3I5ME1oRWNPKys4dEhQR0Y3WEJLVEdO?=
 =?utf-8?B?NGJucDBzMWtEbFVPZll5NnlJYVRwakREVnIxdFlPY1JIbHRIU0dqY3ZTRVpt?=
 =?utf-8?B?aEdQd1pkWXRoRUJub1ZLUFUxYzhIMGFURjk2MjFxZHlEOVU3dFJQT2haSVZz?=
 =?utf-8?B?elBCVk5nVzgzSlZtMGtXelFXZEdlVjFCa1VGMEZBWU5ubG5tUi9BTjlTK3ZP?=
 =?utf-8?B?R3ZzMzYydnNMdmNLaGMwUTYwQTBZTGxpMGNnMzBHbjBUcXN0M2puc0JGenNG?=
 =?utf-8?B?U0ZPZWMxTUtTZVY4QStXU3Y1YmoxZ1krMFNraTNFdVg2a0ZWVFcydXhBTjha?=
 =?utf-8?B?clYyYXZLZlNybFQ1anBtdXRWaDVlVklsRHRpRDJpZmVUT1M3dExmclc3dm1N?=
 =?utf-8?B?MGVmeVpFRlgrVDBtSGM4SkUxbFZBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700013)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HChHCTy9IZFNnyPpZ3/DN8VKjfsgI+ZECtRztZIIvo0RLrCC4WImtgCzPsQI2nXbrqTJRgbyVtQmx1cmWWe/4monJPMnDnKIPbiWriHMwQRPkbvVD+18cLrqVU4cpwrg+EKOS3hWPDF6BPbLCb3nuwIv4ZhN6qPdPkJ8flyG8mk4tlimwqOhQjydR+4sjXU2kaUv/49cXKVR9WZyjYJUZbyRlGGUuR0drxHj0qqXnbEI4ysYiTRy/OIz8S5JeNkTUSGLJbkwG64D1FAU22xTnlO25cPFrCzMdJnKJEWnfq9KhuuXYTHr93A1wkOZQyI+Jvt7LMo6syS/ChQQmTih4AYGAzuai9LS73/Wl+CkFg1CvCCAQGFNS+bUwis8tRNCyJ2qebZUGdRQ2nQUTmYVGvUHWnBZw9CDGEwMhXps0al5PJZmiuxo9ft0huwk+Jbd
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 17:02:41.7586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da34349-4baa-4f6a-27a6-08de627ce0ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006000.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8123
X-Stat-Signature: kcpt8uqcdfumb5bddyytqgjunzwfey1e
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 41CA7C000A
X-HE-Tag: 1770051768-163010
X-HE-Meta: U2FsdGVkX1/0B4hrQMK4ZTONWf1DvX/x8SWjJPiW4btneYsPjQ7HTpCaO1RO67itzBQF+BjQPMz2dkPSXPFqZd1r2xFQJcF+r9Sb2GDMl9IS3TVJJwZLMJDYIbEPTx6p2mj1gglQwyIBBvr/opQT6lMozPjLaXYlpe9Uo36Sfolomur2k1854MBbU5PJb9p9HIDwx/RGLCKORnFs4BEITubsDLa4BbLW3Crq6tPpObMWr71ByhcG+Ofwas+Gu5gPEHWQ169WCnigumVuToxyn8+NkDV5/2Aaw4IVdexacC2FPBkt1h/kLYjWqLpgBlHTh3rhHDy2XGpFiH2ypUVElvsZ38SSqEnx4H84aDAZn6tHB08ldwJ2sQcwaVmqkLqowqp3bWxYjgkgkr0fWJkEro/V5UB0Z8hQtqz9YOI8d+qHWCIWi+0sCHvd906NlRv/pbXg8aF7c98CuyJNLSkcayZPXwf9tc/JWQYUEQH7/uBYaG2QYN4qLrc2GrBCO3qT5mK1m6m8XNsf6zOFSqlCAREAmPJeYUARtYqrpWylxoE0b1H+f9U2JguAFjCEE3xDfogPlAIV5Ub5blGSqQXenODcIl6Lo9Qd44zHGHOCNOYg9c8D+HwwkI0dwOuL+RSgXzT+7m8onKxqqvY0DaOWOX64GLUIaCMeNwFPZzWM0U4ngOqWQ56DN8YMR2iU5+Ral3u1nN9R2HUL828qgSM4jFBi/SBeAAlq9OMs1vExZ9mMzpNCmxDpx3ptuFym+Z1vYVrtX4etmKU9GHbbm2ZpT6e+Xw+f0frvI0OOq6QvtcSDLTLZAtpXpOefbZHfZuUaRWmcj4G6wo6RmTN3QSlntu+M0VdovEUgZH2T+iqzwbpV53kukpBrSTgT7AGWSvD/B+gd2E6Axz+RmA+3uG+EWXtex5lIGvke2ebTf95bufHHdgNYM0ggzwXbbzWRqEiK7uIl2gUpKhPgp8WH9np
 z6tqvcXY
 vH0V+HbfMskcO/RalRphkfQAZJmG0YfV8FyZOCmsZceMvvpXnRjDyWOi31RqicmBCfGPRsqKhD+wlbcerPv1R4WdGWwnrHvB4Dr4KlX9PDufj0s7yCY2v0PG10PsiP55teYrc0V4JFo7xRhDgBIRkxQuiQ83/MFJ/g1JiuJ7qfB+7xv3E/y0XH4JQZbkSkMJ4siApUHQmmvDDBK6TJ2VVTp9fhDFG8OSL7RMRvW+/A3EeFu1waEJcZZlK9DXAveN3QX4ZPFguU+Wx+2K02eZXhsGh3JKqZtlVEzSRqw+mObiIv6ilfPSvnTr6oyYur6+/x6fTWNOgDnD+laTgtc9hOc0okglfEColmHI4OCN71aMSRZ4KXPhhOJbOtvl3gtaThFM3wSwogFCt7pk5VBsBtL2AXaaWmIepc8nx8aRjClxvWqqiS0KPCCb39v8XqssgSGC0YdXWSEh2ujmM+2A+2UiExAhr9WXvj45ZTmk68WGX+p6JWJVzBXdmAjrzBDuUmTTLWa8VS+0Piq3T+bhYoi5mVCKRDn1gNuZVfr21ZStrh0nIhQFWJo71HNbmlnVDnJNGXLVLuskqa3hnrWXulgaDUbKSsIgw06BpdQArunV/DRcj8XfRtv3d8X2zDB59fKChWe/6UDN5H80=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/30/2026 4:12 PM, Gregory Price wrote:
> On Fri, Jan 30, 2026 at 03:27:12PM -0600, Cheatham, Benjamin wrote:
>> On 1/29/2026 3:04 PM, Gregory Price wrote:
>>> In the current kmem driver binding process, the only way for users
>>> to define hotplug policy is via a build-time option, or by not
>>> onlining memory by default and setting each individual memory block
>>> online after hotplug occurs.  We can solve this with a configuration
>>> step between region-probe and dax-probe.
>>>
>>> Add the infrastructure for a two-stage driver binding for kmem-mode
>>> dax regions. The cxl_dax_kmem_region driver probes cxl_sysram_region
>>> devices and creates cxl_dax_region with dax_driver=kmem.
>>>
>>> This creates an interposition step where users can configure policy.
>>>
>>> Device hierarchy:
>>>   region0 -> sysram_region0 -> dax_region0 -> dax0.0
>>
>> This technically comes up in the devdax_region driver patch first, but I noticed it here
>> so this is where I'm putting it:
>>
>> I like the idea here, but the implementation is all off. Firstly, devm_cxl_add_sysram_region()
>> is never called outside of sysram_region_driver::probe(), so I'm not sure how they ever get
>> added to the system (same with devdax regions).
>>
>> Second, there's this weird pattern of adding sub-region (sysram, devdax, etc.) devices being added
>> inside of the sub-region driver probe. I would expect the devices are added then the probe function
>> is called. 
> 
> I originally tried doing with region0/region_driver, but that design
> pattern is also confusing - and it creates differently bad patterns.
> 
>     echo region0 > decoder0.0/create_ram_region   -> creates region0
> 
>     # Current pattern
>     echo region > driver/region/probe  /* auto-region behavior */
> 
>     # region_driver attribute pattern
>     echo "sysram" > region0/region_driver
>     echo region0 > driver/region/probe   /* uses sysram region driver */
> 
> https://lore.kernel.org/linux-cxl/20260113202138.3021093-1-gourry@gourry.net/
> 
> Ira pointed out that this design makes the "implicit" design of the
> driver worse.  The user doesn't actually know what driver is being used
> under the hood - it just knows something is being used.
> 
> This at least makes it explicit which driver is being used - and splits
> the uses-case logic up into discrete drivers (dax users don't have to
> worry about sysram users breaking their stuff).
> 
> If it makes more sense, you could swap the ordering of the names
> 
>     echo region0 > region/bind
>     echo region0 > region_sysram/bind
>     echo region0 > region_daxdev/bind
>     echo region0 > region_dax_kmem/bind
>     echo region0 > region_pony/bind
> 
> --- 
> 
> The  underlying issue is that region::probe() is trying to be a
> god-function for every possible use case, and hiding the use case
> behind an attribute vs a driver is not good.
> 
> (also the default behavior for region::probe() in an otherwise
>  unconfigured region is required for backwards compatibility)

Ok, that makes sense. I think I just got lost in the sauce while looking at this last
week and this explanation helped a lot.> 
>> What I think should be going on here (and correct me if I'm wrong) is:
>> 	1. a cxl_region device is added to the system
>> 	2. cxl_region::probe() is called on said device (one in cxl/core/region.c)
>> 	3. Said probe function figures out the device is a dax_region or whatever else and creates that type of region device
>> 	(i.e. cxl_region::probe() -> device_add(&cxl_sysram_device))
>> 	4. if the device's dax driver type is DAXDRV_DEVICE_TYPE it gets sent to the daxdev_region driver
>> 	5a. if the device's dax driver type is DAXDRV_KMEM_TYPE it gets sent to the sysram_region driver which holds it until
>> 	the online_type is set
>> 	5b. Once the online_type is set, the device is forwarded to the dax_kmem_region driver? Not sure on this part
>>
>> What seems to be happening is that the cxl_region is added, all of these region drivers try
>> to bind to it since they all use the same device id (CXL_DEVICE_REGION) and the correct one is
>> figured out by magic? I'm somewhat confused at this point :/.
>>
> 
> For auto-regions:
>    region_probe() eats it and you get the default behavior.
> 
> For non-auto regions:
>    create_x_region generates an un-configured region and fails to probe
>    until the user commits it and probes it.

I think this was the source of my misunderstanding. I was trying to understand how it
works for auto regions when it's never meant to apply to them.

Sorry if this is a stupid question, but what stops auto regions from binding to the
sysram/dax region drivers? They all bind to region devices, so I assume there's something
keeping them from binding before the core region driver gets a chance.

Thanks,
Ben
> 
> auto-regions are evil and should be discouraged.
> 
> ~Gregory


