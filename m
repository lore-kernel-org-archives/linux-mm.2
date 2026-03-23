Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E9FEC01B1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C626B008A; Mon, 23 Mar 2026 05:56:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFCDC6B0095; Mon, 23 Mar 2026 05:56:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB3E6B0099; Mon, 23 Mar 2026 05:56:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4A66B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:56:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C068160AE9
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:56:58 +0000 (UTC)
X-FDA: 84576874116.14.BE85823
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010005.outbound.protection.outlook.com [52.101.85.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id EF3B81C0010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:56:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=uqIhd3kS;
	spf=pass (imf21.hostedemail.com: domain of bharata@amd.com designates 52.101.85.5 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774259815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDC+MpESOb9QgPOLko7Ss04XLSPywRUEAe9xOdzxjH8=;
	b=nIbyyE3xOy2QDbRnFXhiCuvgD9KClG7n+8+qGRkvAFBGrekoTwSl0hl4PyPut5qfurEYt/
	HZmnne9leZ4GJqmRiAoRHRsFobQtsb5aUv1BjmiZWH3DphVv+M4t3MSmu/ab4B8Z7QgbfL
	I+BuES8Vq+p9foAqciWJpl5wWsUcgFc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=uqIhd3kS;
	spf=pass (imf21.hostedemail.com: domain of bharata@amd.com designates 52.101.85.5 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774259815; a=rsa-sha256;
	cv=pass;
	b=T4Ib9SlJLZWUl76Cf4VRtbDOiJPO+27XsLjWi1NeYJ1f01HEkHBYDi7b+FBDYv4r5oACeK
	HJMHHLIg14Oe5qNZHGaUW7R+D5HoPQMaye2D7hkvp1ZzaBIU9peHjuoNeYrBXNyEHgQ4eB
	RO+i5smjyx87HhvCQKkvYU+DV+dQCFM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gfnmk02Y60UAHrqnW8ucsQFL1/0XQSpl+o3MuybP5FO1vRXdGZNRCNDicltsQuCTlCTEbPV1InIig0Nk+MWeTXR9sHwSQZqRqUGKrm7ipyyCuO7XIa7++C5hIdDJqao3umc6YKITbukhwb0zCafD/0IuumIH8eIWAo10WAGwfKgoPycFU2cT5aAuHRGbnloP326OSGsBEhmHSGKjDhjVYUwK21XF1LmI5Cwx8++1N5q0hcMEtq3i7KEnf5O3HKB992cGK/fKxE7n3OaP+OSORF/ZMbb7MahznAgKDsNWxF5SLv+jN0UhYfxWPsixNZpOW3zdcE4cBpPvqv2VCPSxiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDC+MpESOb9QgPOLko7Ss04XLSPywRUEAe9xOdzxjH8=;
 b=Av2Bdd2BrnxIm4ayRdyDt6Rf+Qu8anx5xl4gvo3WqYCHClnxdTJ27DX7JRcZp/4kOAhJDqVYDUfwEkNFN0DJkremuhEQ06CmPZ2z0JZter4R/jcI00giLDhVGVh7q1F+DEyvVoYQ8sITV8odaH9bbl2K7HInxBejopkHIWSxV/JZOK2SvAZgEoTFtS5/eAzxDMDwaozdDTS0mH0Ll0KV384NSmxtF73KC0gCOMkrc7PUpLpGUru57/uU4j4t4zPH6QdUjye6Ag0nSw2JOx3XtNICdoQboVWHYdc7qMLzoGzFDMN11z5Z0/zxDSV1T9owPHuW0Y+o+sDbXikSHrjA/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDC+MpESOb9QgPOLko7Ss04XLSPywRUEAe9xOdzxjH8=;
 b=uqIhd3kSWF6K8InldXA270YstV19OADuytCr4YqzZ0jmq2tLPSmiby6Q4iovopSEfyywtOaEY3xsMzk0qy3mcVDqBwDM4XARjMxifu9f55kPQ/Bw5EbDJiCfblqPExmh6hDvNjlMUqZ1MGAMwoe78G6ZbuyFR6ylBnzAOS31dnw=
Received: from IA4P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:559::13)
 by CH1PR12MB9645.namprd12.prod.outlook.com (2603:10b6:610:2af::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 09:56:49 +0000
Received: from BL02EPF0002992B.namprd02.prod.outlook.com
 (2603:10b6:208:559:cafe::a5) by IA4P221CA0010.outlook.office365.com
 (2603:10b6:208:559::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Mon,
 23 Mar 2026 09:57:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992B.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Mon, 23 Mar 2026 09:56:49 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Mar
 2026 04:56:48 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Mar
 2026 04:56:48 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 23 Mar 2026 04:56:41 -0500
Message-ID: <868004d8-bb8e-4800-9fdd-ade48e95fe3b@amd.com>
Date: Mon, 23 Mar 2026 15:26:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 0/5] mm: Hot page tracking and promotion
 infrastructure
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>
References: <20260323095104.238982-1-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260323095104.238982-1-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992B:EE_|CH1PR12MB9645:EE_
X-MS-Office365-Filtering-Correlation-Id: f4257c35-842a-4584-9175-08de88c2805c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GCjASRwWYc1GiZkMYdSsNrh60nLIJ3iVax9teklUKSiBF5TUzddT1NMbFQ7cfE1wy46AwJAojo/fAxdigNwjiYuQ0v77t35IPgwzBmmQ2DDh9SIF+swpej3PmLrdaDOgCJUcRZeIpGyMabAomMt9Yp8lb+8GvYFNabzHWqfDM1MxLXaFDbV8BkRvac+NvlNICNfCofhRjtIp6HD6OMzHXUBJdnm2Bd84WxWHxsC/87tNnvYNplqGd7DQ1GKHWOVnL1Ifj99tbqSvavopYjRZz9px+ihGDgLtxVxWodXv60tv9j4+a0t7CD9SJ+nuCqEggHSY+/iTl+VwcskVJngsvmIWS+hqIBpyvV6TdAIEFDaOO4dqODTjur347kT4Jt2SrBm2wCD4qJ7/kddkWyN3C+5DJak2CK26p3/qo0vFPv7GDy4YLwnPvIGwTsQm9YDjTsUE4MFqR+A8lnLClUlHxVhOxA6loD2Awls5C+zW+Dty1nGZbrryUuyborD/gemQlXsYOCgRkVTXjtCd4EAolHaqmDlRjcTkKVy2HFsJqHhBn1CKSzfAWRlpFELqTj4xowyqcXW5B7VfrPvyp3sQhgImTOehD6m+6Yh9AL2zJfZGnqYkGNwCaKBCSOF2j376pcfIIk5KFBEvIbEQ21XrD9rYXKZoFBPgsYnegop5KU13ypH+hEhc2+E7kQXbSYlPQjdcKTyJjLMvIKFs/PCT+Trdujxnlc/urLRwLtk7aebifK8JB7mwKWAbEhcLeNncOKuMP0/U28ManqEgPniRXw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Z4/81kIjSsyrhVmqbi0H3E9otrEwXQ7+nx165EqfyhGTDD/7GU/PT02f/zVs3PiflEcqKTcflGq7u9n26bHOd8AxYG76hikgq36gjvk/xGofdbpEjJOleB3F9gRnAa54vs1VOoRpcRx+2+IujDqFqp6CJZRlnD64YwyKLvHgLjLDaV1JfG2ga7Bsvc+gxdwWNRbbSrBA8BjM01OoJS/DC2rVrzOBHQX63oqt6nzH1SzT+MiDycVp17DX1qq24g1Bz1awT+RSEucY2rDB0cMt3BYds2SxHBrH0C2mF74gVAIGOSHjET3LNJ3ov8G/2ICVl45OB6WGdnTQv/nU36i5J1IgN0x4ypKSk2YiYcQpd+Bd0NfbaJofEHRfLz1kDWOR7wYfsAetdPIfTT+lbA8NlU1kJDInUohsERgPBS4qbBJzWjH4MGmvdVy6Wdz72FLE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 09:56:49.1342
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4257c35-842a-4584-9175-08de88c2805c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9645
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF3B81C0010
X-Stat-Signature: seps3p55piung77hd9bsozf9i68cwmjf
X-Rspam-User: 
X-HE-Tag: 1774259814-288372
X-HE-Meta: U2FsdGVkX18KykCeZltAQR1Kp9OWHkuW4f/OzPcwEptjSNFDPeDrIHpaJJtkPgf5plB4YwL840r3DpywPRKRrEy+fR7zIfzNgk6q1R6B3bdbB6LoN3KRvd9RRbQHkBv3CqTltZstsoph7IC+irG9rYeD3VzRnd9NEKvKEQGj8ug5XeZZbElGr4BYKORvZb/N3aI3Wm4Ubb5zn6MXvJqrJth+LaeaL497NObncNBrco8INMduA2Xu7eNWu1KGG+WpjRgb/gwArK+Slu/IFjPU+yWJTCfSzppuMoVPZh7B8LoWa1uGsT2Ma4AmYmuiKF/p8PWDdR4RZq6H+FzFx91g6SPCmSBpizNdM2Noyjup0jPzJ/sLIzNpep14ViYMLiD/+VkXtMezbaq+HnF2GJYVSrtrnjAWZcBfqWoRNnf//WiJTVpbtGgLhhTK6yXr68KYbN2dvX3Ih0rhUi8vOfi92PDK9ehjbCY6NvvtRVZuEzv5lyUQUoHBS9y9I96ue7wfuuxkxiTb/kOimmpwVTw3eKWTX8Jh3KHVvFgUpfFd5TsmjH5P1uU0AooFY4jB6+Y1I50huDG8BVdJN3P1vrOjeAHRY62JLYToCSLCTq4IB99EPn76q+Y4ejMjVhhFDtxB6hZ8mVR1kHkpnpBvMh6iggbIrs9ZGAXLxNVRbeVAEhAHYC5wIUyM/Q0Bmp/6Lc8Ctua2wo+0760Hp0Bi62b9tHzvsM6xpUx3+AYSZHBYvlQYv3msHdyA1fG8Hi/nhmOOTTQvtlqdHk8u1ZxpU1wGblF1x4X1KEErhzE74LeWfgblNtjrj+tKB1GaEu4KO5XK5ettU5dTbnDuytljcUA0pcd/npVMAlM01M2KLHTSE4TEQHiSXm8tYpdLmqOGQus+OrtgreipdwNGUSfGnnmk5w5fC8CUNVXA8RfgCu2FXxcSxtwbnSnCRq0xFZM03yByD8aecXVtGcF11s22p9C
 Pb/WR1kY
 XkV566Kl80PSaC7dQmlDB4Rc7ufso3D2L1oQt/pj9CwiLLKI4X4pGCdCzxYAhoOCOTYCMcr/FzkvMMcTv6Bl58SQilxBAz/CvKf/M4lo2Z563HZBHtJh7AooqR8ZK87P4aZ8mqNFnbP8xcKiVzZOp4DQYI5Y4EHj18a9Z5m0p3REcqFqhkz7ZffHeOTnOvmRJLT/rbbUhZzj2M4f+unkorAla2pT2P1lm3zXAztAo6AbJL6g5Vb27FkFuttCUfYFKKN0oU92JI9laS3PlOtDPMws67arYdB4u47emAjwrv8njO+RX08f8Cy3YIZMONOmLfVjDLqdV2pK+VBvFUB8xRVsrB0P9KpnnExWDTxut6ETETvfGd3gQ6QPaLHLv0spnCf9zG+rWhcRmoI+CFYN7TrlZo4zyjTf7gW1+CZhUI+F/j/Mn70fGNgiTpl+X2ca/zQXeEYX80YrWHWs0IWEAO4liB74CUyxDiX81syQgi2Ni5YQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Microbenchmark results

Test system details
-------------------
3 node AMD Zen5 system with 2 regular NUMA nodes (0, 1) and a CXL node (2)

$ numactl -H
available: 3 nodes (0-2)
node 0 cpus: 0-95,192-287
node 0 size: 128460 MB
node 1 cpus: 96-191,288-383
node 1 size: 128893 MB
node 2 cpus:
node 2 size: 257993 MB
node distances:
node   0   1   2
  0:  10  32  50
  1:  32  10  60
  2:  255  255  10

Hotness sources
---------------
NUMAB0 - Without NUMA Balancing in base case and with no source enabled
         in the patched case. No migrations occur.
NUMAB2 - Existing hot page promotion for the base case and
         use of hint faults as source in the patched case.

Pghot by default promotes after two accesses but for NUMAB2 source,
promotion is done after one access to match the base behaviour.
(/sys/kernel/debug/pghot/freq_threshold=1)

==============================================================
Scenario 1 - Enough memory in toptier and hence only promotion
==============================================================
Multi-threaded application with 64 threads that access memory at 4K granularity
repetitively and randomly. The number of accesses per thread and the randomness
pattern for each thread are fixed beforehand. The accesses are divided into
stores and loads in the ratio of 50:50.

Benchmark threads run on Node 0, while memory is initially provisioned on
CXL node 2 before the accesses start.

Repetitive accesses results in lowertier pages becoming hot and kmigrated
detecting and migrating them. The benchmark score is the time taken to finish
the accesses in microseconds. The sooner it finishes the better it is. All the
numbers shown below are average of 3 runs.

Default mode - Time taken (microseconds, lower is better)
---------------------------------------------------------
Source          Base            Pghot
---------------------------------------------------------
NUMAB0          119,658,562     118,037,791
NUMAB2          104,205,571     102,705,330
---------------------------------------------------------

Default mode - Pages migrated (pgpromote_success)
---------------------------------------------------------
Source          Base            Pghot
---------------------------------------------------------
NUMAB0          0               0
NUMAB2          2097152         2097152
---------------------------------------------------------

Precision mode - Time taken (microseconds, lower is better)
-----------------------------------------------------------
Source          Base            Pghot
-----------------------------------------------------------
NUMAB0          119,658,562     115,173,151
NUMAB2          104,205,571     102,194,435
-----------------------------------------------------------

Precision mode - Pages migrated (pgpromote_success)
---------------------------------------------------
Source          Base            Pghot
---------------------------------------------------
NUMAB0          0               0
NUMAB2          2097152         2097152
---------------------------------------------------

Rate of migration (pgpromote_success)
-----------------------------------------
Time(s)         Base            Pghot
-----------------------------------------
0               0               0
28              0               0
32              262144          262144
36              524288          469012
40              786432          720896
44              1048576         983040
48              1310720         1245184
52              1572864         1507328
56              1835008         1769472
60              2097152         2031616
64              2097152         2097152
-----------------------------------------

==============================================================
Scenario 2 - Toptier memory overcommited, promotion + demotion
==============================================================
Single threaded application that allocates memory on both DRAM and CXL nodes
using mmap(MAP_POPULATE). Every 1G region of allocated memory on CXL node is
accessed at 4K granularity randomly and repetitively to build up the notion
of hotness in the 1GB region that is under access. This should drive promotion.
For promotion to work successfully, the DRAM memory that has been provisioned
(and not being accessed) should be demoted first. There is enough free memory
in the CXL node to for demotions.

In summary, this benchmark creates a memory pressure on DRAM node and does
CXL memory accesses to drive both demotion and promotion.

The number of accesses are fixed and hence, the quicker the accessed pages
get promoted to DRAM, the sooner the benchmark is expected to finish.
All the numbers shown below are average of 3 runs.

DRAM-node                       = 1
CXL-node                        = 2
Initial DRAM alloc ratio        = 75%
Allocation-size                 = 171798691840
Initial DRAM Alloc-size         = 128849018880
Initial CXL Alloc-size          = 42949672960
Hot-region-size                 = 1073741824
Nr-regions                      = 160
Nr-regions DRAM                 = 120 (provisioned but not accessed)
Nr-hot-regions CXL              = 40
Access pattern                  = random
Access granularity              = 4096
Delay b/n accesses              = 0
Load/store ratio                = 50l50s
THP used                        = no
Nr accesses                     = 42949672960
Nr repetitions                  = 1024

Default mode - Time taken (microseconds, lower is better)
------------------------------------------------------
Source          Base            Pghot
------------------------------------------------------
NUMAB0          61,028,534      59,432,137
NUMAB2          63,070,998      61,375,763
------------------------------------------------------

Default mode - Pages migrated (pgpromote_success)
-------------------------------------------------
Source          Base            Pghot
-------------------------------------------------
NUMAB0          0               0
NUMAB2          26546           1070842 (High R2R variation in Base)
---------------------------------------

Precision mode - Time taken (microseconds, lower is better)
------------------------------------------------------
Source          Base            Pghot
------------------------------------------------------
NUMAB0          61,028,534      60,354,547
NUMAB2          63,070,998      60,199,147
------------------------------------------------------

Precision mode - Pages migrated (pgpromote_success)
---------------------------------------------------
Source          Base            Pghot
---------------------------------------------------
NUMAB0          0               0
NUMAB2          26546           1088621 (High R2R variation in Base)
---------------------------------------------------

- The base case itself doesn't show any improvement in benchmark numbers due
  to hot page promotion. The same pattern is seen in pghot case with all
  the sources except hwhints. The benchmark itself may need tuning so that
  promotion helps.
- There is a high run to run variation in the number of pages promoted in
  base case.
- Most promotion attempts in base case fail because the NUMA hint fault
  latency is found to exceed the threshold value (default threshold
  is 1000ms) in majority of the promotion attempts.
- Unlike base NUMAB2 where the hint fault latency is the difference between the
  PTE update time (during scanning) and the access time (hint fault), pghot uses
  a single latency threshold (3000ms in pghot-default and 5000ms in
  pghot-precise) for two purposes.
        1. If the time difference between successive accesses are within the
           threshold, the page is marked as hot.
        2. Later when kmigrated picks up the page for migration, it will migrate
           only if the difference between the current time and the time when the
          page was marked hot is with the threshold.


