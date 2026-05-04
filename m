Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A689FCD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 06:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C4A6B0088; Mon,  4 May 2026 02:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C266B008A; Mon,  4 May 2026 02:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C106B008C; Mon,  4 May 2026 02:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D94A6B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 02:23:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47FA11C14C9
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:23:36 +0000 (UTC)
X-FDA: 84728746032.26.6A9B79C
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011066.outbound.protection.outlook.com [52.101.62.66])
	by imf25.hostedemail.com (Postfix) with ESMTP id 17C80A0002
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:23:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="pfRp/pmG";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf25.hostedemail.com: domain of bharata@amd.com designates 52.101.62.66 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777875813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ofz1rWH2X0FMTbHUzBnyypWRWI5tyZqpysqqcykfjHU=;
	b=2p7mwhNSj70yYoPoa2TK6J1YKpE/xW3x4Coz/PHV1RW6dUHM/HrZbt3tf5ed+RSWLkwLiD
	KJdfanValNjdlAnt4Usgl+KX7NBFbg7FJT8RrNvLpcR+AAvG4rfZMx91482pDMVJVY+r1y
	efpiVCP1CjchFF06NX+6T4PcuYEG8Dg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777875813; a=rsa-sha256;
	cv=pass;
	b=H9hsIMZIXuVpGJ4x6HMHuiyz+snzCU/0C2gUkcTjv91JSTUxaL/3W49KrxqnZ+2RZ2cKDX
	u4Qo0IB3xb8382OYecUX7Vori3jAEdtVXilxEvaq1CfdxApxMA3Hora3aXdoUpRtHPEMya
	rVkihNtsXDxY+nT5uuNHOih1wXzYr9w=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="pfRp/pmG";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf25.hostedemail.com: domain of bharata@amd.com designates 52.101.62.66 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bTEMk9sueCUOLL9QsWCvA1fgrLdMtZvv8z2n4QmoXtee76GtoparBz/dAe+rqWUg3CPIzZGbK1m7/bwtatajZ+rocDTz24655g/IZ/VMgidmDvJQjs77AFybfNgr1UiRat843NXCyY8bkGUeXJdOBSrLBWDBjr7psF/BeQzZsjyFnv/2upuxMMg7AjNagZrJkCv2lH4OqxdlkTQgTTyoOw4cSPeDj93gi4W/FLdfbYPtOo9vLIofwLv52HWlx3FpcjKNCyjiOD/MmEXGUn0/HwQzvRxrkIVvSfP7kJtLsUBoDZpaxQmIZnnzzxuJdFKqvnTxvKqIXz0niLxQ5Ecz3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ofz1rWH2X0FMTbHUzBnyypWRWI5tyZqpysqqcykfjHU=;
 b=GIbfBeI3J+QMvwWRtCH0apUdXaeEooKJqfzp8G3RW4FTHkPbzsD+0s69WQmln0BFvpRfhDqnY6Gp6M/d+Pg1ZLXUsMSMWZ4RhbPzrOAfSlrvyqu5gvQRs42978rmBmDX8LBoe7fYyfmW/OAaMwPbVef7WyAaI2FbFnGSEKdKz6QXDTI6ORrkrSu1U2DA+LbrUGHkpcBtAnmIxsCWr8VFmaIx++eXV1ev9oNSTwPkUgWogVX57DIEXnvupIwTSlMI86YmF/6pbudzAmXdTF5Zr4XVObkRV+Uz5OMbyj9TYXoTo+HAfpd+g24igZ5Ih/1NqKeyUSFFLkQY0wlYwTUgTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofz1rWH2X0FMTbHUzBnyypWRWI5tyZqpysqqcykfjHU=;
 b=pfRp/pmGUoT4ijDWQAK5vyP8piBvwbePsWbUuydzU0HJlWV9tqdgaHnlR/VlpcdenIdGouVPqKam3hW7UDrpPONdPCnVB5/JD0Lj0QoT13FyeYSYksn7hxFBeUPOjqLEmdEZzk2aukADeWpr0OioJI4CmDfKJGMu9Hba3tWHzOY=
Received: from BL0PR0102CA0008.prod.exchangelabs.com (2603:10b6:207:18::21) by
 LV8PR12MB9181.namprd12.prod.outlook.com (2603:10b6:408:18d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 06:23:27 +0000
Received: from BL6PEPF0001AB4B.namprd04.prod.outlook.com
 (2603:10b6:207:18:cafe::a2) by BL0PR0102CA0008.outlook.office365.com
 (2603:10b6:207:18::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Mon,
 4 May 2026 06:23:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0001AB4B.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Mon, 4 May 2026 06:23:27 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 4 May
 2026 01:23:27 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 4 May
 2026 01:23:26 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 4 May 2026 01:23:19 -0500
Message-ID: <18421811-cc5e-4586-9a59-18e6245c678c@amd.com>
Date: Mon, 4 May 2026 11:53:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] mm: Hot page tracking and promotion infrastructure
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260504060924.344313-1-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260504060924.344313-1-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4B:EE_|LV8PR12MB9181:EE_
X-MS-Office365-Filtering-Correlation-Id: 4632f535-0560-455c-7e67-08dea9a5a731
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zs7pTn/49MCrGyJrAaILlx7T0cHViEvHDcjQ5NBxuR/UODsbcmwJnEaQgnWG/u30VieT83BZ6A20kBMhlX0cGqVwexf24gzw/h9r28SBCFPj5OvIn+PCENFIDBS+CEgPoPlnXpvRhgJTsKfR3oClN+xnG7fPBBtuwj7LV1ufyDpc/MgCdeSvqmVSft9cPsjG+WLmQpSiHhl0ZVRXEs/6h81fI4sMZC/okg8nsB9LWMJNGu3G+4HlK4Odv8CW363oDikdz+sqkzv4XsiMt/dRsuQHAxiV4AH0a+W7bQdG0NBEISmrNFnYkhMa6AqZFNLKgOkZ6e8vrUIicPGl+wvhgpEyxEkXrXmrsgmNeAAJiGathAPeITAvCsuygiS2x3ONYr/lNAD0UesdeyoFH+n3sOkECIH6sDJocgjC+jd7NmAOu9BmcqeCnLRGd+5vbxrW1IfdipgddYEYWy3DwcV1H2ztzEN6IqmP9mFd7J8jC76ZHX3Vvbm7B6g6LT8eF57TqmIKGM2KlPoBg1NzjEfIhjnutoFoIqegcEXI6P7sygI6OYA9CCYaQCSkownvMiUPd7iWIF6k61Z01mSiOKoqPZ/akagckNGMTRC62KVWqZSiG9+wo2XgM6gadpBVVoMav/6+4f7nWXfz+AoT0jPI9rkjpFNIp6+TkOacsE2XBnQoEkaVyMssze3XgosVgF+sc3NLzzyHFqPJARQyWP2t/FwCsF5lvMfSwk4lzOlSirE=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Mx0c/7AmK+Hlvxw8NkhtDwHqdK8tUWZH81dmNsNvIeEubDjC/8gxwZsup0d6UGcqwucJeMp/RzATjpmp8sTcykUg3zuZdFlR+/3Mgpa/UMAtCJJhmO7ww+XNpAmbpwn7+yIXklenmZAxkbfxL7yECLLCqmXcG1fawbMu0GdYVGM+xFG1B12dqhvTW2NP7YdfVcQYiD+uQHdx7Oop+ddXAOMJYJ49LHMeva/C9uRWzCXEcxCw6RXz/3F2HGW+oK5Fni6klYDeqOfGMbSYaXDXvNCbBBLZ+a1QswDtfVTzizyTe8B0S4eIiwr45SVRcrVuzQCUPGpFlpbVgUwouEFq6vou2/UoQuPaHuodSyWgEmJfUMT2ItEgDPsEKbZZBb3xaKIiipSo2siaEGhXTPy9nWcBr2LGM5PoderRklIE7oWuCpZv8rCmU3UNgvKnEwjy
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 06:23:27.2496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4632f535-0560-455c-7e67-08dea9a5a731
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9181
X-Rspam-User: 
X-Rspamd-Queue-Id: 17C80A0002
X-Rspamd-Server: rspam04
X-Stat-Signature: syttodxw8rohynk5ahg9sh4ik5mzmkwc
X-HE-Tag: 1777875812-538557
X-HE-Meta: U2FsdGVkX1+5voHCHQoAz0M+fHRFIo2YhT2MG+aK1R9moD9bGNwtxvE8dwbgTsPnfsFFf8/lSji6c5yDGB6dlny9zvw3pl/yYAYP8dFblhBu8oY3ULEaf8B0jIpsPCwfYSwSEusO0CDn+c9d4dvC8txSmlYa+eZ9x2RLtwUsXn3UaQr81KOGjqIJUzAavJMQ4lghNRUZOtxayy6xnOH7TF7I+KKweHq3r2cmiXQ6lyS2SnovtmawQGHHHAMSFlnBU4ltskfOn+0fLb82+6ljFZU6cURHfn4oXerH5HhJUqi6UHKyXhoPlXtaK5FwSPR6IGuHA4y4citZKMaRpfgco50ulnSZ+dFV6qROcfX3XTDJCS8+MAE3GFDgT2mUG1m7bmDUzR0rpXVU9edkd8sjhXZbI0w3PbRJNifxLKofBuusZHfx8zz4Z0zWUzN4fQbm1OfjQtTYfi+n2K58Py5qlhwhpqVOsvzCPcqGwhLLuHjz0025pF1S6e0g4+ULYWINb3+qlzuavg7CNuuOLjJPU32gJPl635hQP9OEg7G0dQllbvpbqaAov8Af00XK3EzAmawOR7KndbMEjlajWseBNqy4QTL7D7AyK/BuKCdDBWMpq223ReFsEekYq0AdykFEXAdkF0vAGgob2LdALj/jnxnLDGPkR9/SfBWKD3bimiFKCrvFSQu7H1YUapus5SOBbefwtQODeuOj4lkVzjzFQ8c/9Yjk26/xRIN6RlFVy7K/wdon6Gp4G0tsrsjqNld3KTfO+1/blTGO2d3w/Ptz5lRORcEqxMJdI5Zfu2dsifgmK+IuvHU4s/mzxrHeikTYnyT/gyE6DQmSs5C4L0QmVPeMGFjBabA+3bvqUNlZUINwXYe9LfcD4ZsuD2I4EWHyjxoScBYvG0Q24vlX+WOhH2VCj9r+/cJhuHZ7ckpp6ZgzZNYRRZiVd7oOJ9l33eZN9em/smiUEbBoE/nVc4i
 DiRuLhi7
 qQA1IOsf+ndDfnzdvMCY89b5MSV+IoAkGUtO7g+BpJmqg74gobIDsoWRfij7vmi2i+ZfDC9uGbXu8Lhbb4+LaXjk0pvK4Yf1wnLM6DD9/WW6uWisu4WbzglHRVEQFEH/l7MBZmhQ6XbptB3WQ15ELxfTUuzPiMGHxFqAueR9TMgoxfM8S0ZHu2s+H1S7R9opNRZpUkgD9PSt83O6/xH0QXfR76M1in7nuxok5M5kjOZZb1UlRXrNhleLKY/ix7tBFUS3erEo9fAMagFPemdZfDsSeIVCz6uQ1cy59hbHEr1FeUNHPrfNn0sKt1M/RxMR481dXw1bYjxsa+U0Z0ZaUjq1ZUVRyW+8qhB6cR8hvDPFbptXzhsmuELznx5ore57XSyD8rqlAN7Si35S+qvq7HHKhYvkPITDBj7bk6sGUlW99c3ydmtXd3BKueWlzJE2Lz+0LxH/HpKxQaOcxz9dG4e+e159Srh9QcoC7DxulJrkekhw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-May-26 11:39 AM, Bharata B Rao wrote:
> 
> Results
> =======
> Posted as replies to this mail thread.

Micro-benchmark numbers for IBS Memory Profiler pghot source

Test system details
-------------------
2 node AMD system with 1 regular NUMA node (0) and a CXL node (1)

$ numactl -H
available: 3 nodes (0-1)
node 0 cpus: 0-255
node 0 size: 515563 MB
node 1 cpus:
node 1 size: 258034 MB
node distances:
node distances:
node   0   1
  0:  10  50
  1:  255  10

Hotness sources
---------------
NUMAB0 - Without NUMA Balancing in base case and with no source enabled
         in the patched case. No migrations occur.
NUMAB2 - Existing hot page promotion for the base case
HWHINTS - IBS Memory Profiler as source for pghot

Pghot by default promotes after two accesses but for NUMAB2 source,
promotion is done after one access to match the base behaviour.
(/sys/kernel/debug/pghot/freq_threshold=1)

==============================================================
Scenario 1 - Enough memory in toptier and hence only promotion
==============================================================
Multi-threaded application with 64 threads that access memory(8G) at
4K granularity repetitively and randomly. The number of accesses per
thread and the randomness pattern for each thread are fixed beforehand.
The accesses are divided into stores and loads in the ratio of 50:50.

Benchmark threads run on Node 0, while memory is initially provisioned on
CXL node 1 before the accesses start.

Repetitive accesses results in lowertier pages becoming hot and kmigrated
detecting and migrating them. The benchmark score is the time taken to
finish the accesses in microseconds. The sooner it finishes the better it is.
All the numbers shown below are average of 3 runs.

Time taken (microseconds, lower is better)
---------------------------------------------------------
Source          Base            Pghot-default
---------------------------------------------------------
NUMAB0          181,393,365     184,331,381
NUMAB2          42,287,528
HWHINTS         NA              50,422,862
---------------------------------------------------------

Stats comparision b/n base-NUMAB2 and pghot-default-hwhints
---------------------------------------------------------------------
                                Base-NUMAB2     Pghot-default-hwhints
---------------------------------------------------------------------
pgpromote_success               2097152         1961087
numa_hint_faults                2358069         0
pghot_recorded_accesses         NA              1962696
pghot_recorded_hintfaults       NA              0
pghot_recorded_hwhints          NA              5532979
hwhint_total_events             NA              5532979
---------------------------------------------------------------------

