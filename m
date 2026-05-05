Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C3B5CD3436
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 10:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E4046B0005; Tue,  5 May 2026 06:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494CC6B008A; Tue,  5 May 2026 06:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383E16B008C; Tue,  5 May 2026 06:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 235BC6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:42:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C289FA03A6
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:42:01 +0000 (UTC)
X-FDA: 84733026042.07.40AD622
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012008.outbound.protection.outlook.com [52.101.48.8])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9FC33180005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:41:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wzhP3WNN;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 52.101.48.8 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777977718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dgke4l99fRaNQoXHoXTyK0hl8BDR3mDCA0ljzm4voRs=;
	b=iTV/a2I+S3OQt0zdC1MSe4NTas8T62gaZmNVl496PBd8x0PIG/ipH7FRX+Po0dj/CfXx0l
	2O5OjdJfc/WkgdLSPpPfFy6wA/BS8B76WU8H7TmkkltqfoG77rL+VF82dKSEHKo8oEXDzO
	Y1wU+nKtMIz1cH437xkdgNe+Wq3wEgY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=wzhP3WNN;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 52.101.48.8 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777977718; a=rsa-sha256;
	cv=pass;
	b=IPMuF+DUX/OOJb5VRGkqdAEvOFfBhUgIfQSH9XhPss8dliUNEAgJLH/0MxVzkMrM028g7b
	SfdD3MsWL8foGc2uIAkR0Wggp/WWSaXb9bDOidnXPkjgtqWdD0Ip0AL5lJgmKcPdnnbJm6
	GcymTVjYGwQAA1sbOiRHFFh1LAKiixs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZlH26Rv1uEI5TQFY94h5z5Ug7DO3/dCzIGODa6ZnnoaQxdL9y+R8wPIKFBTr5B3V4z+3TZIoY7mh35Zx88OwkZa4p7RLdKH14kX/Sp652g4lowlO+Dth6nYjJYCuYgEYb6oE1nFgWao2+ugRMHjlSMKI3JvVQ3RCD3XCxELiZ0MZX9Q8xUARrczMEoITbtgjJEdz3weR76j44Ks2aNjJvTqf1Bf0ip/rrOCXi294H21skXqDxrsNEAAa5gKeajefRWSjw3GqMQWgAT9UbPhvOC7ntGTYRNSKv4lh+/udZrs7ccE7iPvbO34YLEhKm4rYti9tHKjBAbwn/4LeKQe7Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dgke4l99fRaNQoXHoXTyK0hl8BDR3mDCA0ljzm4voRs=;
 b=bl0/ZxPS6c5B/5eat/ADhN0cwGzSWJVj06Mz3TO9KKGPc0AqHVq6xklPVcqHdxIxFqnIXe6ciJJDnIJtXq0vqhfb15F0VriURUWlNq02gP/rE0EGo81keGnVNzmUub8NkmOXE4t8rv+yJkdBqx53JbzsXUt8jAlkW6G8hEtm3XnH67gGonbUjivUI6x+r7KX2t0cA3BCmZyMiCKlyd8L/Xf20YGqO3WP3goRGEEMqfUHQWQCV91EYnvhNZ0lI3SM2ExaU3nwE98jqKQhvZ0DP64h1P+wewbTPR5AzOQfng1yPFSWpTO5qCp3bUb53xU5SRZC2nNpeUWg8QdyMR9ayA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dgke4l99fRaNQoXHoXTyK0hl8BDR3mDCA0ljzm4voRs=;
 b=wzhP3WNNjErLDkkJPEfqHaN6k4rWiQRaDqAf4DlV9P+z4j9lZQVyrSWfSOhGK6mWJ4ls8kiJKmWl7La1KvS2APQMNs5ANLEnS8zjq2a+Lvwv9s4rMrOEq4vEVEbOAIOjQTlxEB5qxpBc6h9labxhyg7G08tDl0OB1pSqvq66lOY=
Received: from BN9PR03CA0463.namprd03.prod.outlook.com (2603:10b6:408:139::18)
 by SJ5PPF4C71815F9.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::992) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 10:41:52 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:408:139:cafe::d9) by BN9PR03CA0463.outlook.office365.com
 (2603:10b6:408:139::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Tue,
 5 May 2026 10:41:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Tue, 5 May 2026 10:41:51 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 5 May
 2026 05:41:51 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 5 May
 2026 05:41:51 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 5 May 2026 05:41:44 -0500
Message-ID: <5110e313-8c1e-4f73-b77f-68d20c2046c8@amd.com>
Date: Tue, 5 May 2026 16:11:43 +0530
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|SJ5PPF4C71815F9:EE_
X-MS-Office365-Filtering-Correlation-Id: b971cbc0-4903-4da2-b9b2-08deaa92eb16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|7416014|82310400026|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WA5jmHy+QvlLcj5sh2H2vgqBB8ufyz4yZefHYUdHODlFVcIxhIEKsLC5B0a/N/NaLDaZYLNEDSBptP/SyENvQD0rROYbuFmk5vOtu+4uCTnrEr02/ec5IWf3c/d2HufQrPvywI3qA5DDWpLr9MuI9fe+y06F266X7Wk/VVEmHAd5iLflDERS6RwNLPRdtXNBRRdR6Tos7n7+oK74KVqZEMGnrti8DISCjkI9qSBmLJXngt7pRAaXjl1vWIk86JqbOkSSKyG921o8t23S4PaHTvcA8F/C+egonX+GVgfUR3mxyLJwN4AidbrCPcI9EVXs9gW3q2bX+V0hNfC+EwvWh9hfvfsFs+Vz9V7Kbzy6tpbNr423/NRP99PzsYwdHz7Ud7jyaZYsZ8AJxX+QclucIV5U0qm+av5amiSralB1uvXMlZ10S27wulcFzkkelXMo4pPZMI+e4BMA22mX+HC8aZFgX6C+MptZkClyDBu06XRyRnktB8GM9EhvYMYQBXdFW9PC1o/ZCopNBl4cdChBl8dElGJjF9sj8X6VFM7muKvZ4ag+jJJcBqTES2Bu2c0rhgs3TNLpOLkWmkMcVvpcAp43Noxvvf+ne1mc5hlmztWiTA1lggXfIUE1EFo8R4EUreQlVZ+tZZpyV1X1hoSvtgRVCV7msbbl0PZJGrGqIf4EK67ur53EDMs78jUzVGFCUGrLesa/kCg1SReWW3ieWDTUWs42jLAqydDOW/rzOys=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(7416014)(82310400026)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SlaD83D4qUqGKBtd+XvmzrtRLMYIRxeJI6o5FUd4syrb89chgWY0n8Hjvn4VjV4MM/IT3jid/dJwjr5yqQ2A9kAag37l1AdSvskFqyl1V3OvEJppIqH/0bzAwo119XfTdiMY8zzOdCg4qc7fBB8ddUDkxKmZU5B07k5GGqh0zY/txVFLDs0/I/rh09O05Goo2p9Ibf1LnYOHhIxSSofQmKzq8Ti/h6BYL5ikcVqb1PE98138CqJ6OhUOeAClSs8KpS2K+L79+vt8YSMvaW5qSsTgtZ7XqDAGKun9SR+poDVXTFhzMdzjBz9ILTaorZyveR8idLP4oEkVXAjRpC4nhv26hTqUxFtPg9aLAxX2fHrXtcHV+Akht1VibZeDt0kk0e4Q9NN8NfLG3pghRitAHLkHECGLYYt3G1ALdhqkE5hU2yYaTPeNMbYPeLs4ZLO4
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 10:41:51.8842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b971cbc0-4903-4da2-b9b2-08deaa92eb16
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4C71815F9
X-Stat-Signature: omp9ei645b5yf6ynj5i4ro7d5c8mwyrp
X-Rspamd-Queue-Id: 9FC33180005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777977718-582589
X-HE-Meta: U2FsdGVkX1/0O5XsHj2Ahs99nD/ik49k4e30fiKrnhnD2pP6rmvZhnvECX+7Mi34kEGgzpuJM1T9SJ++WhtICoLIlCsmvJqoP4XGi2IIzyUXGQc3oIsO7fw3wx/WgnBmS9+rhN6bJHESl9Hiu4OwiPrnjSD/UAXKbnLNLNLzMCrhFk9fSPUNl9Kw4yni9fEP4vF0qOh5DpvowQRynDW1DvClZ0swNjUnnv3TXaFnHH26WyzexA8nM6TbHfPAyr19Vqs3KLGC1L1XGwUJXPeUyhYYT7Z15VXIdk6ckGAUywnHZVIk6cZzlazyK7xCSqM0l2olasyZ7j4s5oeTW+AYUEvHvgRiCPiXuzP/+i6v0A9LlmM6G75h8vu6OSRQ3BCkqlNL0rZFzxR2s00mW5k9h86vXx0muizjBOjh9pOYDKTgrCdszjKKKv5Pswgg30inA33FQec80RIJXOBlzf1BZdYc/FxV21tMpKOMf/+1j1/0nDz0dMb0CuSofNJrfScExtxzLOx1hPAadNiYbZA0xzIkXqB8//9P8wcHD/V1sd84MNPoXXYY5EO0DDvrtiqcwI3gSuZhjf09AZxmskqdsMMyolP8Z3UfkjmdBgZqwPA5i7qFTNot6mxwtIkZWE6aSLYdQut4jfoD0ABXfbsxmypEPvbn6lN510zSyTsEDQomHO/6Gy7RjSwWfy1NWYtQ7ApYFd2oXDthjly0eKuRQFJy8WhyIg8n9aiBC0/TWoA6n1fyNwrZwV0y34gn8r2PlRS10Rr72r7HI2FVgJKLYWqskXBZZMYZ8Wln8Lns1/u/O2rhnhQ4po5eDWMRD6EByWVI6OttfknCUwwkLfBeIcyBmyQ4XvXcA5HaYF4VdfLdg9EuB5aVwtatiGTgzr54ngUJoAP2AgBOdLOn+ABj+KvLa0qtPAZFKhxx2Yl9lxJmjYweTbwybHBQDYpaRydvWQ43RWrcn8NimR2y0di
 ycQV+K2N
 z+3M102tDRo4icWbVoeETmVJxJO2l/jLv3yE8vbEbSKWxCHIdXhxnfkhvfegVt4MxMmDAqYUJgqpvMYCzlJgowC87UeO9L0m7BhpluV/m5n2c8fJXUp3rlUxmK4kVHwvmC/2dClvIB9ufVI3XiuM0rl1+vnj5asnYb2xFXCC5PtLfhuSLyUjAE6XEUqYYuElnrliPQXxMUxkIKTz+29X9/T1xyGeFg+0/Z+Lwuq7pX6gjmUGeoSPYRWDoUXGN3uj7ZIexWV9wuj28VJnFIP2e0hF2XQoTpOyPcPm7GnoaFBxy3yOtXm2dwr4qnKYZj6MRmlSP/aUXon4TIJlc8ZrStgyJpR19GUqyV1ATWDtK/0LfB0cG/lmiOwAVTsD6YghPs6WGCJyAr++F6rOIocu/xlz5nn550cHEKtHErGFWuA8MubXgPb4+CaLw6V2Re/eflAS2Mi22ZJV7uoh8QqhzNKZGgQ0+II9mZwKjbcPXrdJ2IeI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-May-26 11:39 AM, Bharata B Rao wrote:
> Results
> =======
> Posted as replies to this mail thread.

Graph500 benchmark results:

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
         in the pghot case. No migrations occur.
NUMAB2 - Existing hot page promotion for the base case and
         use of hint faults as source in the pghot case.
NUMAB3 - Enabled both regular and tiering mode of NUMA Balancing
         (kernel.numa_balancing=3)

Pghot by default promotes after two accesses but for NUMAB2 source,
promotion is done after one access to match the base behaviour.
(/sys/kernel/debug/pghot/freq_threshold=1)

Graph500 details
----------------
Command: mpirun -n 128 --bind-to core --map-by core
graph500/src/graph500_reference_bfs 28 16

After the graph creation, the processes are stopped and data is migrated
to CXL node 2 before continuing so that BFS phase starts accessing lower
tier memory.

Total memory usage is slightly over 100GB and will fit within Node 0 and 1.
Hence there is no memory pressure to induce demotions.

harmonic_mean_TEPS - Higher is better
=====================================================================================
                        Base            Base            pghot-default
pghot-precise
                        NUMAB0          NUMAB2          NUMAB2          NUMAB2
=====================================================================================
harmonic_mean_TEPS      5.08026e+08     7.48633e+08     5.46257e+08     7.45101e+08
mean_time               8.45413         5.73702         7.86245         5.76421
median_TEPS             5.09236e+08     7.25058e+08     5.40525e+08     7.63752e+08
max_TEPS                5.15244e+08     1.03391e+09     8.51317e+08     9.7552e+08

pgpromote_success       0               13809474        13763582        13763155
numa_pte_updates        0               26746117        39502157        36368086
numa_hint_faults        0               13811769        24248272        21172314
=====================================================================================
                                                        pghot-default
                                                        NUMAB3
=====================================================================================
harmonic_mean_TEPS                                      7.00515e+08
mean_time                                               6.13109
median_TEPS                                             7.06813e+08
max_TEPS                                                7.63164e+08

pgpromote_success                                       13762087
numa_pte_updates                                        93632490
numa_hint_faults                                        70566306
=====================================================================================
- The base case shows a good improvement with NUMAB2 in harmonic_mean_TEPS.
- The same improvement gets maintained with pghot-precise too.
- pghot-default mode doesn't show benefit even when achieving similar page promotion
  numbers. This mode doesn't track accessing NID and by default promotes to NID=0
  which probably isn't all that beneficial as processes are running on both Node 0
  and Node 1.
- pghot-default recovers the performance when balancing between toptier nodes
  0 and 1 is enabled in addition to hot page promotion.


