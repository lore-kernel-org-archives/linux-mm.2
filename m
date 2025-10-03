Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4CB8CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 11:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289678E0008; Fri,  3 Oct 2025 07:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 261578E0003; Fri,  3 Oct 2025 07:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150418E0008; Fri,  3 Oct 2025 07:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC69F8E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 07:03:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A037313BB10
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 11:03:24 +0000 (UTC)
X-FDA: 83956516728.26.F80AEC0
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013036.outbound.protection.outlook.com [40.93.196.36])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD6B416000C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 11:03:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=renELuEA;
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 40.93.196.36 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759489402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=95SrH8UQ6PJ/Mqro5QgCwcA/wkJ2vC3HvWnVZTFpvnk=;
	b=b/NI+lYJClZ2lqUWNuAF7BWF/NukAAmFGoYzD7ocSVKDfiH/MDSnskw4e8Y4NirF1qbveG
	6pvBeU0Vu9NR0wX66yfUStynQth6B2qfmRZlrSyVfxj4pe0EZWUV/E077kTRKO+Yx4M3Xn
	ipp9MOVaFaBqsk+Q+4fNRDM7qFns/K0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=renELuEA;
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 40.93.196.36 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759489402; a=rsa-sha256;
	cv=pass;
	b=ib19P+VEjQNP1IhzTF0twLB889FPcY7flOcbBrJh7Obesu6k4GU+W7mVq+FNtr3cZbRGAt
	S0IT+coGxeDBAyJ/Hqru39Tx2BJbzXb+quLCpDXvCCNPrKb9M6PBigooeAm2r2fYbuLNhA
	cO6CZxGAscY58oVRQjf6YzV5Il7YaD8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WkDzrMlcdtHEoYdG+y7KAg+YMLEFATe0EjBoAfoQv2jBct4fOl7aaUNC1MhQktCaVypfopVcCQRFVeRakR06V8SSVCG8FBBIhyjl2M+ce36YuZ5Mwvs4eMZId7CriSNm5BP3Mgg49uhjSeKZpDGQnEzP+BXS7mGYWjk+yZAckjzXpzf5WC1BWNGNhLW6aUa7FlC0GWuNE4YrYfUVvDGI/ryEmxBLRT737cxAxL8H1G+cYALsJDnEWwQOyloBM7RyrYm7BZMCs+VsW0E73flmagKnOUSDvPA7NSVwsS2a9ApRpV533+cQqNz6OT92g2HKQrp9G5tlDfElyYtYEPvHUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95SrH8UQ6PJ/Mqro5QgCwcA/wkJ2vC3HvWnVZTFpvnk=;
 b=IMrJ7thRV1KYx0cZmNuaNen9YNcHx0ICYAbHvHGj9/wgM5qUnyJGwDl992VfpM3c3gjvltM/xlGME6tC2LAWH4iSUmGQHEX84jiHEXK3M8MTUzW/BX8DHOcqUx9ujLwG8C1/bdmfmj/ouAvYEfNI7Q6Ai3TuqsMW8uCyJ/Mh+0i78xlLYTcIEVZrIvZwEiYvAexgCPBLcxJiLZgNq/KfdkRXdZ1FbeE9mik/3LtXHd3tnrXh0HUkYJTUZo/qmzhnhnvVC31ZFWTOtsUy9ghnN+J7JPuR8ygAZcqQQiYMmn1RKC56ZQkNIIB20uRvpkh95R6gJNVAUkQkFPUY4tjOJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=huawei.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95SrH8UQ6PJ/Mqro5QgCwcA/wkJ2vC3HvWnVZTFpvnk=;
 b=renELuEAmC0bxBGgFh848wsV5AYcM8LmE9vWwuf6mPWxIgWVJ3yQGaofuLlaP4Ic1B56nCiFMPiDuwgqXRlo+NdWIHbhH4icIXrtkRlIVBejmOHfRQNADfHvM2Pb1DSeZOLvxlkaeGiwWswnAVItJWz9xTSwjZ8iNY28TgxmXK0=
Received: from BN0PR03CA0035.namprd03.prod.outlook.com (2603:10b6:408:e7::10)
 by SJ5PPFA5F0E981D.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::99d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 3 Oct
 2025 11:03:13 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:408:e7:cafe::2d) by BN0PR03CA0035.outlook.office365.com
 (2603:10b6:408:e7::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.15 via Frontend Transport; Fri,
 3 Oct 2025 11:03:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.15 via Frontend Transport; Fri, 3 Oct 2025 11:03:11 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 3 Oct
 2025 04:02:25 -0700
Received: from [10.252.192.21] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 3 Oct 2025 04:02:18 -0700
Message-ID: <66b9c552-61f6-46b3-a773-87958429322f@amd.com>
Date: Fri, 3 Oct 2025 16:32:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/8] migrate: implement
 migrate_misplaced_folios_batch
To: Jonathan Cameron <jonathan.cameron@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <gourry@gourry.net>, <hannes@cmpxchg.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>
References: <20250910144653.212066-1-bharata@amd.com>
 <20250910144653.212066-3-bharata@amd.com>
 <20251003113629.00004fcb@huawei.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20251003113629.00004fcb@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|SJ5PPFA5F0E981D:EE_
X-MS-Office365-Filtering-Correlation-Id: 51e75c12-2250-43bc-eac2-08de026c7137
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T1ZGSXZUTUhtYUxOdjBpTVFtRUNRd3lobEN2OTJLc0YrMXlSeE84a0UzV3Zk?=
 =?utf-8?B?MmR1SFNZNGlTd2ZseGY2ZmxMNDFDS3RiMmFRUGwzUjd3S3dJdDVQck9GdlB0?=
 =?utf-8?B?cEpseExueDBCc1VVRUhnZEtKcURURVZGS3N3RWF2eFRVQ1lCUlh2NXNsb2Vv?=
 =?utf-8?B?Z1A2dVVGYTc4dlVQWUMzSjNZS2pOazVody9wTHBHSTdEVlZJeGpsbmdKZHBv?=
 =?utf-8?B?SVMxdU1HbGZEMVVZWDNLZlc3bWNZdVE0TS9QelBiL09ISnJzbWxyeHdiZ1ho?=
 =?utf-8?B?WXEzL1d6Ri9uK3ZQSFoyMGN6UkxQZGkzV1ZVTldGUmFORXd4azFSa2YyaUU2?=
 =?utf-8?B?Q2JrUWlMc2VuS3Nhd1M4cXJ0NmVlT1VmK0pPTktTaVNGaEs0OTcwZUJPNm9y?=
 =?utf-8?B?Rys3c1NJWGo1VXJqS2ZRTHVWdUl3aERoQkdtWG5aV293OUZwR25hNHprcDhS?=
 =?utf-8?B?NTRFcGJRNjhRWkU1RnRYUVV2UjdpTlZxdTc4VUc2STBreVE1RU9PL2crSk1T?=
 =?utf-8?B?VmNSN2ptVCtuVllIc3RtMWtZbTloZVNjckVrVWlwbE5OaXVEejFUa0YxOEVM?=
 =?utf-8?B?VU90WjNCbk9wblBuRFZVYWpsWFhzSGZkUnZ6YkdFM2pyazQ2VDc5NVhCVVMz?=
 =?utf-8?B?clBqdi9QU2p6alRkdWVESzdudnNhRUhJZ05wekZuTS9PSkl2ZFB2SXMrcXJh?=
 =?utf-8?B?ckZrc001dVV3c3VnVzNvZTJ1aE9MaXFhRkxpMiszZDZwZGJvNk1KbXhEY1dv?=
 =?utf-8?B?T2d5N3dDaDFLdkxYTW04ZW1iblVpTUdrbm5sS3djaS9aNk1rV0FMcDd0b21V?=
 =?utf-8?B?N09McUwwWW1zekoxakNmV1dJYktCZ0diM3ZZV1RsaDNkQ1EvajNBekRPaytk?=
 =?utf-8?B?Y3p2ZjkzTFZIYUg5Y3VxNWdEZStTejM4NFk4dnlDd0drb1dSUU91bHpEYkIy?=
 =?utf-8?B?eGVyNnRianBoM01YcFRsZHhvQ3pHVXZvcDlHQW9EMUZxRW9uT0VIZFJDc0M1?=
 =?utf-8?B?RkJ3VVUxblFEc2xUV2xrNm9UVjlpOTY4T05VbFFkMDg1SkZUZTI5ai9LbHpQ?=
 =?utf-8?B?QlZmWnU2UWM1Z09jUm5mcFAzbGJ3WFYxVGx2ZXYrVXg4NGJ4RVIrWi91b1l2?=
 =?utf-8?B?ZmRVV1JTUEJ1d0Q5SFdmTGpjNVl0aXZqS1dDaGgvOEpnNk1FMjRIa1lSRDBC?=
 =?utf-8?B?MEthdE44RVRXdzBBN3R6TFZEM2plTkVVM3Jnb3M1VCtVSVczWDVONnB1bVhZ?=
 =?utf-8?B?ajc2MzJMeENRT09pZmxTS2FTa1I0a1ZqZEhxenRoSlJYdXdRNk5rQW9wNDkx?=
 =?utf-8?B?OTVrUXZOR21Cc3dZcG9MU0Z5ZFZFaGRtVlZRZERzaTZVRW1aYjBzT1ZyQUFK?=
 =?utf-8?B?Rkt4RXROQjVQcm1yQlVLNVlwY2gxOFFHTUlobjFqMVUzMnF6MXVHM0dhc1Vu?=
 =?utf-8?B?SFpUaE14TGRaeGVGdDBoYmZ4WjNxZlU1ek5wYlFBeUNxWTNteU1GcDdESTBF?=
 =?utf-8?B?bXRmN2pQZWt2SWNKaVVFTTlmZHNDdVRzMXVMczVndDF5OG5OblZ3TXVOWjIx?=
 =?utf-8?B?UDBKb3d5eW5DbUsxMlJwcmFGMHAzUGl5YXh1c0hkTFE4OW92a1VjeDZRVUpP?=
 =?utf-8?B?dWp4ZVFvUmNIN1lCNlNsU0lhOHRjSkN2bTlCSG1OOGtscXVMZzM2dmR6WlBi?=
 =?utf-8?B?RktDQjlzWWhHc2JUZ2FjQStnSXZWOWVwbk82ZnhYTFloWmp3T0hFMDlzeWtI?=
 =?utf-8?B?Nmh3cXhiemhrRXcyc3hPL25FTDRnU2lmdjlRWVN0L3NXZ3A4ZlJ2d0VMKzlG?=
 =?utf-8?B?aTNhVEJRQ1pNNlVBZ2V1cTdCTmFmMW1td2lvaG4yQ3lpNHdzTmFLdXovVVRi?=
 =?utf-8?B?WHpZTWVxNW1TL2JLYUNxanhwS2M1bmJuWGdDTkNTMWVoMnJ3a1FiQ1JLUlho?=
 =?utf-8?B?RlZiRnR4bnVSaVc3SDZ4Rkw2MUtnbGZkeVZGZ0Z1bFlSSDdjbTlheTkzQSty?=
 =?utf-8?B?N1o3RmdGWEtncW9IY09SMGRWc1pzQTRDbHM2NWgvRm1oUFdxTlhLS0RMRlR0?=
 =?utf-8?B?YzJ4R3JZSzUxYUdNYXpqU1ozbXJVU0lOY3poVlFhWG9zdHpHVGQxdjJPcHlK?=
 =?utf-8?Q?BRQE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 11:03:11.1961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e75c12-2250-43bc-eac2-08de026c7137
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA5F0E981D
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD6B416000C
X-Stat-Signature: 1szhbwxk1zykkidxqsfw8aekeah7fncb
X-HE-Tag: 1759489401-936494
X-HE-Meta: U2FsdGVkX18kjeEP2PE/ktPbhSDpeY/1LsvQgAETnwn6XEWc1iyxcmFrc4Mo/bTBvI/XoKTnpcBmLcVpSPp5ktIoV3pQZ8h5yo7K76eXjExKPYhbKGsWRwKW1YpDOiE2q8hqmyUd6Ql6/xeUVlnj+5a529WTS7vVYZS6j7k8CwCl1mEjFqXLBJcJNB0J040Fa9l/k84mBztH4AuXJXcEn9N2AHOe0Jnow8iChQjfgPA9ignIgXowfdZXbKUN8e3Sx8mt6clPxnJLuw1KoFMDVPaqTJ7pFLGHNeku9m9eIUqZ3DkpFxtcmQz/yAigQ4w68BfO7fymFTKzkWNhkKmp7UXlVUQt/Zd7ABKKwilplRNxyI37og+W6Z1Zh+cxXwE/HHG/BY9BSsffSZ31asPFfp5lkLtLmf1dIK5OS/nsKry6tFJgTPLWqebB5CdGyypTPZTqNnn2nJ/hFqDainOGGop9XogZQMCE45h7dqUFTyTxVRG42+75CuIQ76DU7jwIm1Rvc7K6MZngSBgOIjJd3Ch1mrWVtdJMfYcQRchFkd3XwdY+YCr7Qv4ewLkiOTDNNguqt6tT0xoSUx3rjHVhbQCMLRgxejPJkY3cf1ADDjKlQgk/JFLSH5BWwBNOvNFmRM1umeFk7nZjeLM5kwXHtPYq2RbKXFq2n3CiABmMkmPBwakVtDvbC0cKDPGF64IsQeazHLB/bJATqvaXiOfOXOtxAfMwK/7Umq0059T5ZQuLYr6o9OT5v0rYeZQBdBxL4PAEFVrc50sLLC/mS555yIMcagaqn0UV49WeN/eFgP22l+svDU4aChzdkSOACpEkVJPGvjJ/+6a20CXKgww7rbl3KxVy8MGnZu6IH6NkWVeKS8VMhB61J78qEeCBvWRpDKQR/XsUzz2CkE4klksrUC2yJWP5ogmuTbQXrTiKLBdQ/pK38IP5xWTQhSk92aXW7VctJRanpgdQeOoEhTt
 DT5GIilD
 bL7RL1ntVPtTHijIFBjMma8ln9/14QhLW06GLAG9HvtFkljDlrvcnvSW2bi4aXoXInMkpmV6cWpAaXnK41WihfT1Gof5d9idwNEcRYPEj/WTujLE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03-Oct-25 4:06 PM, Jonathan Cameron wrote:
> On Wed, 10 Sep 2025 20:16:47 +0530
> Bharata B Rao <bharata@amd.com> wrote:
> 
>> From: Gregory Price <gourry@gourry.net>
>>
>> A common operation in tiering is to migrate multiple pages at once.
>> The migrate_misplaced_folio function requires one call for each
>> individual folio.  Expose a batch-variant of the same call for use
>> when doing batch migrations.
>>
> I probably missed an earlier discussion of this but what does the
> _batch postfix add over the plural (folios)?

https://lore.kernel.org/linux-mm/15744682-72ea-472f-9af1-50c3494c0b78@redhat.com/

> 
>> Signed-off-by: Gregory Price <gourry@gourry.net>
>> Signed-off-by: Bharata B Rao <bharata@amd.com>
>> ---
>>  include/linux/migrate.h |  6 ++++++
>>  mm/migrate.c            | 31 +++++++++++++++++++++++++++++++
>>  2 files changed, 37 insertions(+)
>>
>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>> index acadd41e0b5c..0593f5869be8 100644
>> --- a/include/linux/migrate.h
>> +++ b/include/linux/migrate.h
>> @@ -107,6 +107,7 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
>>  int migrate_misplaced_folio_prepare(struct folio *folio,
>>  		struct vm_area_struct *vma, int node);
>>  int migrate_misplaced_folio(struct folio *folio, int node);
>> +int migrate_misplaced_folios_batch(struct list_head *foliolist, int node);
>>  #else
>>  static inline int migrate_misplaced_folio_prepare(struct folio *folio,
>>  		struct vm_area_struct *vma, int node)
>> @@ -117,6 +118,11 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>>  {
>>  	return -EAGAIN; /* can't migrate now */
>>  }
>> +static inline int migrate_misplaced_folios_batch(struct list_head *foliolist,
>> +						 int node)
>> +{
>> +	return -EAGAIN; /* can't migrate now */
>> +}
>>  #endif /* CONFIG_NUMA_BALANCING */
>>  
>>  #ifdef CONFIG_MIGRATION
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 7e356c0b1b5a..1268a95eda0e 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -2714,5 +2714,36 @@ int migrate_misplaced_folio(struct folio *folio, int node)
>>  	BUG_ON(!list_empty(&migratepages));
>>  	return nr_remaining ? -EAGAIN : 0;
>>  }
>> +
>> +/*
> 
> Kernel-doc perhaps appropriate?

Probably yes, will take care in next iteration.

Thanks for looking into this patchset.

Regards,
Bharata.

