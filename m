Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB87FD74EDC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216496B04EE; Fri, 23 Jan 2026 10:06:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CE016B04F0; Fri, 23 Jan 2026 10:06:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051FA6B04F1; Fri, 23 Jan 2026 10:06:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E50DE6B04EE
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:06:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F587589C2
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:06:49 +0000 (UTC)
X-FDA: 84363555738.13.BB6914A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 035CF140013
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:06:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hx6wMMiN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bAABLWQY;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769180806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zj793MzmwBspYiXXuqFpmTQHpQwzHkMQPwYQ1rVgsJU=;
	b=lC5yJ8pR7vqxewkqM2tvWkFux3CV/3VnHO+UUEQa+1P9i8LPYmMSk5g3oI8U8JWBd88tND
	biqLEcJQ3jLipMn6ZkxL8znWW6gJDCvKiwXDoF15ZrIujRnYk6J3mrrYFgdUhfraGHKBYH
	Wr6YtP4qtcqefwehbAnif5bkz3w27RQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hx6wMMiN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bAABLWQY;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769180806; a=rsa-sha256;
	cv=pass;
	b=nTjupWuOMp+00kKcNn52y7/LMDMUW7BWUEuOsWV1q9YSd9wMXgyQwah2WR9ESfYD9E4S1w
	Js2qfzoLs/hBpwT8D6WTyJyRd60mv1wrOIyl2zoHG5VVzdCOym1oris6q8+Fc2bCkLQdsj
	3xbDZeG2fHFDIOAVgwzodlGE1m7zOw4=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60ND6QEb2973522;
	Fri, 23 Jan 2026 15:06:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Zj793MzmwBspYiXXuqFpmTQHpQwzHkMQPwYQ1rVgsJU=; b=
	hx6wMMiNR5PAdLUrkA/AEQDWH4zYlOa0Zivq9hcAcQ0BSu7PgIqwzz115uS11N25
	5iJ+nXVjNv86Pmj2N7P/aTtZdcvfpjBTXdiQDjWeQh2IE1tIlLAGdiJjRonGxRCf
	q790SawCYdiAnVQqICijzQQWCMaDUBosqAsvuxdl38+M9O+zERyZCorDL/KjCi/a
	MGlZxUKQ+GscF32SFBfYk3zMCW/YsMp/q8twGPxoIOdF0shkccab/NZWZiCPk7YX
	22uwqZIEUMoROXz6AFj0FO8aydOfsgDIFMGUeknRHXqVNHq1y9Cu+dSKsha7mxiX
	BjodzD+xrhMXvZMNF4mYUQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagcy4df-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 15:06:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NEUppH035914;
	Fri, 23 Jan 2026 15:06:34 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012027.outbound.protection.outlook.com [40.107.200.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bux4yabg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 15:06:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y8RtBfs4r6hsLoHTWnOMHTGPusLT7i3gv871/cwTlR0fOjClukWDphygq2YbZHeimyezdU/LqNNwlD9uf+dDnfANDPHGeTMXL/5h0JtkCnsnRBzvXWZJTpKnJNpJYMsDN1qZ82RCAZ+P2M7wG8Q1Ap4frNwCvByjxIeY6Tt5/Ng7aG+WoyzKyCJk/UdPfKNeFzafjsNPDhhiNtKMp7zVgn81zCo5CrFU7SmNM7e5dzsgld2gP8BZb3TjNh6mDox6zzZKXB00wgm+Jg649gcE5cz4X3NU5f+ueCEWftKnT+cK4erWXPKpxlzZZi91SmgoVImHT9e+Tf4glCyq17rywQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zj793MzmwBspYiXXuqFpmTQHpQwzHkMQPwYQ1rVgsJU=;
 b=HXektERyuWVYGSh1xPPNadEQH5OIbqvgl0kt3m6cYVnd2gD3bjzdOCtgD3lvnkUQ2SirkZbpcgCbndEmDPhisf4Bc5riOLqsLDiNu96BdlLxUtAoZOP83trk312dRVCU0tCm0lS32b9tUpv9C5dZVQPn8cVYCfJDR2KtK0MUHPbbhrUxfqYxfyNzoIIsarWAGtbKD9ire6BzlocYgO9cEnyDYZvanNaE0eB1rG2HeyQMX8BuyEPPbHRmxYoyrX7jnkOPg3kFG/O9XSPvFn9OPp4ZZBrcSXlNpQmxuEvgMkalDFWqlLQdCcgJC1p3zPgm/kutu4w14S2n2p65S5O0bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zj793MzmwBspYiXXuqFpmTQHpQwzHkMQPwYQ1rVgsJU=;
 b=bAABLWQYtW25+veSTmjN9X0berofjrX2IaITqZEzIoGDf94GDDIx9MqfPoa0wvTOqwtNlv90G55Kb9pvMYhIm8bcUkW9Op8HjLaUNup3JrkJ9HGfam9jqJsn0ujpgMf3gfC7dnlWlgIbuYpOwZ18Ke74gEyZdURLd+25wF8nn9c=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SA1PR10MB6469.namprd10.prod.outlook.com (2603:10b6:806:29d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Fri, 23 Jan
 2026 15:06:29 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 15:06:29 +0000
Date: Fri, 23 Jan 2026 15:06:32 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 02/10] mm/vma: document possible vma->vm_refcnt
 values and reference comment
Message-ID: <d2775458-6479-416f-9432-599a06ccdb3a@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <a28f56dbe5057385b07498684dfb105918bf3644.1769086312.git.lorenzo.stoakes@oracle.com>
 <7876e97c-9afb-418a-8ef7-5f4f306b7eea@suse.cz>
 <CAJuCfpEyxqSfiK0M4VfKmZnp2OGYm-Le882aFNhPSef1fSCT0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEyxqSfiK0M4VfKmZnp2OGYm-Le882aFNhPSef1fSCT0w@mail.gmail.com>
X-ClientProxiedBy: LO3P265CA0027.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SA1PR10MB6469:EE_
X-MS-Office365-Filtering-Correlation-Id: 91388604-03e7-4cb1-d811-08de5a90fc95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?amhiK2ovdys1VklTeVJhT3RIOFQvUUVzQXRrTVhvVWYyNFdPaVZtNlpkMjFn?=
 =?utf-8?B?Q05FdUhoZkVwV29NekFsWHQvbkIxZVVFSEpCNXh5eGo5UFhDcEJjV2lKRnVw?=
 =?utf-8?B?R1J5VEh2VzRLNlYvZzNYZEZqL3JZdTFQZnJNUDA0dWdmLzJoS2dlUC9RNEhl?=
 =?utf-8?B?Yzl6Zm05b0xValBPMjA5TVJwNkdzc3RacXZCbjJveThoMWs2NjZQNm1NSzVz?=
 =?utf-8?B?b3JzRkRKbEtsTlIyMCtrWHFWRnFURjBQT0cvelJNNFZtRS9ZZ3ArUzJtVEcz?=
 =?utf-8?B?Q0xTZXBMRWI5M090endQby9KWWJ6R1ZuYWJ5OG1Cek96MDJNeDhRSmdZcVBh?=
 =?utf-8?B?TTRwRmtWVzBSdEFOcFF4UkpQSklDU0g3RUV1cGEwVE90RjQ5eFZRT2REL1JH?=
 =?utf-8?B?YlljdG5nbGFraUQyY1hBRXVDZ2V4RGpvOHEwRklyK3pKa1g0T2k5eXBVVFg3?=
 =?utf-8?B?UnlWemJhaExBUUJsTVNDN1dZMUJLT2VrbG9xeVdrbGFiTnlYT1JtMklLVFky?=
 =?utf-8?B?V2hWTlNEYW92MXFQRTMyOUFOSWZKclNzQnJLWngwYzk5bjlRMDN0a0Z3b04r?=
 =?utf-8?B?cUEyYTQzbHNyaUNDWDlMYi82WHdielplMTFTQ0RpNHI1aks5alNrLytKM1VP?=
 =?utf-8?B?SWhQdzFXU09vZzAzT3VtVDUrZCsrUjZVTEtySG4xbXlXWHZFcjZvUFNaZWlT?=
 =?utf-8?B?dnozanlLSXRvaDVCK0NsQ2lFeUNSUkhsSTI1VkM2cXZXek5wUldLUnpGcFhG?=
 =?utf-8?B?WUhmVCtzZnFTeWJDVnpQYldpekdrOWUxMGp4c003M2FJY1Q4a0llL0VmRVc4?=
 =?utf-8?B?bjk3cnNkUk54cmV6MTZFVDBYVEt4OUYvQngycFRaYjVNRm5HZVVML1ZCT0pT?=
 =?utf-8?B?b2doZWxFNzZpTzJwZXF1VWJGUXk4NC91YmhaZ1ZzeVFvSkEzY0Zhb0Y2YUY2?=
 =?utf-8?B?TXdsdWJObGI2MnFBZlY4T0tyWHpwTHZRbkNCQnRmWm52cGNza0oreGIzc00w?=
 =?utf-8?B?TkgzWklOWTROdXpySlo2ZkpmRWp1YVZ0V0YwTGtBbFdjRDI0cXd2RjlkbGVW?=
 =?utf-8?B?NndLOHIxWTdkcE5JNDY4Zk0wWUVwbXFUVHRoSUdqNVgrYkdEWHIwdVpENnlU?=
 =?utf-8?B?Zmc1RVdtQUpUT2ZuMjhzY3VEUStvRE1ud2RUeXR5bXBqckJ4bFR5bU5zaGFF?=
 =?utf-8?B?MTdiQk96VWRyRHFhVGxsdmIrR1JSanJIam9ObWd0K1MyUHhlSlBPM2NaemUy?=
 =?utf-8?B?S0h5b21uQ1J0VlM1cjNPRlZoUzNLL3g0bDRPQjd1aFFWRFQ2MmppV2xLdGht?=
 =?utf-8?B?ak5Xc012Y2FIcDdqVDRqSEt3dmhhb3BwZ090aUVUZXc0N0FGM3VnUWRTYWFy?=
 =?utf-8?B?c29NdmlxaHk0OGMyVWRHS0YxYlZwZURGMUxEV2FDTExFVTRrMG5aL3ZtRERs?=
 =?utf-8?B?cy92TTVQbVlWZkpaUEpHUzU1d3FXQjBKeVZ5RWdSWjRhNThhcXl3Qkd5YjJ1?=
 =?utf-8?B?cVhpRExtYmdSOUdjNlVOYlZHc0RPSm5kS1dHaEdqb3Vya2pXRVUweXpmeVVk?=
 =?utf-8?B?blZBU3NmTzlxY05zQnNPUUQ2WG56MlFtaXpEMG12blZGUDBIY1ByLzJ2aVFT?=
 =?utf-8?B?ZFVjYy9SWDdCb1R2VkIyeENieWowcDl3NTVoTFJkc0kyVE9YV0lkRU9HMWhz?=
 =?utf-8?B?UkIzVEZiU3YzVk5DdVI2YXpvRTZWZlFUVDM4TXcvQm9oVzJNY0dTMEU0NnA2?=
 =?utf-8?B?QXVOMGhMSnFvOFZ0MFZuVDV1bktmZXQ0aHNKUjlmbDNpd0t5b3FueWlqelE1?=
 =?utf-8?B?YUFmMElETlhyT283S0ZmelRySXRoQnVzUUNZN3BnaG91dHFOc3VZNFg1YTRu?=
 =?utf-8?B?dVpoZkZyUU5TOVZEUlVqS3I4a2Zjb25uVGlhbWxsdDZUL0pTWGN1d2VZZHpK?=
 =?utf-8?B?Vm5IeDNoeEtjV2tYOGtFMVFGODJ5RTlhQURaaGE5dnVxNUJ5QlVXRHpGdGV2?=
 =?utf-8?B?M0FYcnY1S0lTUHNwMDU0Kyt1b1JCNnBqMjRDY3pIUStFMzZRV1VGSjFhYW92?=
 =?utf-8?B?eHpwc2tML2ZUT3BTcVJQa2FUQWxWc1cxcU9ZMDF3aExhQnE1QlZlR20xMnkw?=
 =?utf-8?Q?1MNY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0p4V2dmd1hERlJwSVVOb3ptcitaNDJ3N21uTGtzVThlK0pQUWVzM2RJaWxX?=
 =?utf-8?B?SGxSYkVpWmovQlVVV3VpU002Z0RJVEZBUkE1SGdKRFhOZzFBc2lpb1pmRHEw?=
 =?utf-8?B?bkpkaFpuUHJYK21MeWhUcnFaYXUxT3VMRFIrWC9JRTBmdDI2aUlXQTVSL3dX?=
 =?utf-8?B?NjNpRXpiQTBPWFNERDVrM3ZGTlM2VExBVE0wV0lieHFxaFJNYXoxK3NxVnFa?=
 =?utf-8?B?TVpEYWhVY1podHFvdm5EVlBLRy9WTk9kQzlOWmhpSW84K1U3NTN1UzR0OXpV?=
 =?utf-8?B?Tmc1bE5iMit1N01HdER6bUI2alhuc2xUSjI2bEdSNVg3dDFwV2lGbWd2ZzBa?=
 =?utf-8?B?dmtnZWlpZUgvQVFKS3crVzFKaGZITEEzMGZvaDZKZzY2Vk9sYVgwdHJmUVBE?=
 =?utf-8?B?QVpyRG5aTktrYTNkNFZPWjFPTGxPY2U0VWR0TkZNMnp2cmFWRjA2d0owRTBV?=
 =?utf-8?B?RUdwTjNsa1FCYVVVUFBhS1laRW8xTVphWlBQUXRONVdHVDVpWE9KZ0hzTm95?=
 =?utf-8?B?Zm4vTTFkaFFCWjdIZ3lDTlgwUDdCVEdOZlNDL3JaNEFIeUJzcmNVYTlzNGJk?=
 =?utf-8?B?bVFhSUJlY25qYnlzZEg1TDF3bmNvVHlscjE4ZW1pcDEwYjQ1VVhBd0krQzBr?=
 =?utf-8?B?QTV1QVpacjNZMlZNdThSdmt3dTVzUFZUd3o5Z1BvanJGaFZuNkw2TkRuKzYx?=
 =?utf-8?B?RUZpcjN6MFRkR2dVcEV2QlFOMHI0QkZ1ZVFySERlanVIdmpFNUp5eit6a2d0?=
 =?utf-8?B?QlpOUDU5amFTWkhWaVRiTVZ1UGZqQXNIbjJ5dHRFOTBpcEZGVUFLRlAzb1N0?=
 =?utf-8?B?aGY4amJWWGdMSnVrWUpaSzZVd0dIZ0pFK2VrcnMxcUlic29pSDd1R2ZIWXlW?=
 =?utf-8?B?eTc4Zmo2cUNtMmpta1NJb0JhQ0c0KzdJYjR6TWEvcURRQTUzbm1jUFFqR1BJ?=
 =?utf-8?B?OHJpem5lMUI3ay8waUNmOUxXdForSFF0NjRZL05xdWN6bEY2WWpjKzB2OURs?=
 =?utf-8?B?NTQ3OVlMeTBQb1RpZDJzK1dOMlNSRGJUMlNQRnRnaXdQS3BsQVZGZnVTakl6?=
 =?utf-8?B?SWI2RXk4ZjNXOFhndWhFTUg3ZlpoTWl5OXJlM1l3cllkT0V2ZW5sVXVsRXRn?=
 =?utf-8?B?cXhxVU9uMzZmaEFxd3E0S25sN3Zidk9UUW0wMk9zUGtHVlpOMmJRMU01RVM1?=
 =?utf-8?B?UEcwNjYwelJyYW91RHo5V09oZjA3RFZHSDR2bmU1YkZ5NkY2VkFoRnB0REg0?=
 =?utf-8?B?UzNrMjdLZ01jNG44cEtSTnhuZ3ljcVJTMmN4T2ZVTVVpandBQm1KUHM0T1Jr?=
 =?utf-8?B?ZDdsUnpzQWdXVG40RDdHakloSUVuYnJ2U1ZJb3Vkc1phcjZGdjF4K0VYbWVS?=
 =?utf-8?B?WTF0MlNVQUxWWkpndHdEb3M0ZmRUWkluZlE2ZXRGa1lPdXo2d2NuMFZFUEFL?=
 =?utf-8?B?dmZqcmh3TCtaV0RpbkpyVmE0bDdWY1kxYjNZZWtDRi9pcEdkTElWT05EUFBM?=
 =?utf-8?B?TlZyUml1ZklHZGliV2QzUFJob2FzUE5iWlBGZVVVVmtpdFB5cG1iZEpGTXFZ?=
 =?utf-8?B?YmxzZmJsMFlDYWFSWFpJaXc2OU5lVVB5K1FTZDlXK25tNnE2Y3dYUVhJSWFi?=
 =?utf-8?B?NituT25BOXZDOVo4NWxCYVEzSG5PaTNCZnduYk9DalE5RkNFdCtSU1NOU3dL?=
 =?utf-8?B?NUNGYXc2d0hmZXdHdGFTNWo5ZUFGYUttaEsraDhzTTZWbk9ETkJoazdCSnVu?=
 =?utf-8?B?ZHFRbjVDT1ZyK1R5SkdRbWFzWUU1d2VzT3NrSEJ1ZFVka0MxcHBTM2RXT29D?=
 =?utf-8?B?MTdWRGdwQ0R5ZCtnS3N5aGRONVZjWTYyclRaOGtucHozcHhJODlqWTZYcm82?=
 =?utf-8?B?dXU5VksxbGxOejRlYlczZlJxWmIvS3I0SEVOU3V1azl3WjVaU3dNZjgyK2Fm?=
 =?utf-8?B?R1pvR1JSUUxreU1SUW1uSlRhU2s4Znk5MUVwNWN1bEQwRXZYRWdrejdwQzlw?=
 =?utf-8?B?S0NLd3ZIZHZ6RTRtQTZIMHJKdDVWWUd3Y1p4amFNZjloMGxPSGFYM2U0QzFE?=
 =?utf-8?B?NFRLUjRpREFXMmFNTTdLclZNSmZxdkhwQllnSS9rN1hOenNpUDhpdWlpQWNK?=
 =?utf-8?B?aVFmUVc4K2k2b2JyRmZ1U2tOZllBSlVkTERtdWM0MU41clF4alZRRnZsWDdo?=
 =?utf-8?B?dHRYRVhTVGNKRmpJMCt3aldpU0FvUUFlUno2a0E5WEFMVWRkYTVxNWNIRWxO?=
 =?utf-8?B?eTl4VXJ2MW9DTnVJQzMrNGNUL3FGVndnNTE0OVhNRG5OOERlSmpxYzFnOVVB?=
 =?utf-8?B?S0tNRXZFbkFRTUNwWllDWHNlQ0s2b09JWkdTb3hNMzNFU1B2aFhKUGFLSk5M?=
 =?utf-8?Q?QdnhqpNiYfqIU/og=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SA3vCIO03+3Wkr0Gr2hhrtIHBuRhWadZVX5/lfGPBJnFji83f4+z6K4Pzi+PhGTXJhzZMuINhKx32RFiF2W0Ukl4rFRd6GVkHyXlLNvb7tV+JrkdjcxhdfMGl2dg02w3SVNYc3LhIFvdKVrLz8TyG3ZKpxNhqiPwVTVlXVkjESTUlWrZyp9t+/dbgjDiQfWUCbD80Qz2o+jMuIahsFOeJmokrDx5aCDc/8HCfPF/NMBVZMjVoqPGOLWvPLnfywCVKfjEX6nvvb6lukRr6hCh+jKncTmaxs4anS5dSf/F/2VeCFxebJ0AtWYx2ixHsOndOu+CYSC874L9aAUflypSbIKrtPalTU2xOBwUGEtCv61QWvftaEQXoxLEA/vGV2zTqd5LioFCjmOdfGT23TM+dYWRC7jy3S0+1fw2OY/idEd+oRoQSyBEf2KJMfsg2TsWmu6FsZrBjVZ2OFFZFUwfU5VBnPT0sburpdFpGp2Jah4ChmFUh9xcq5WoaljJ2Ebd92SOinia8qddsb0UYns3o4xVdI5V91I1hjLCR+34IDAW4705FyUHLkXZ8OaTbVGi9zyEtYTUXWWo7otVN9jdrno+WjOvxaoFbM5e8xA6sOA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91388604-03e7-4cb1-d811-08de5a90fc95
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 15:06:29.4455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j855opYRwQ5TZAl/wZIkIh3jiQs+wKqdApnbanff4Tai22T6gQSWEO3b/qcvmHX84Z3aYYVZLoiOKMKPKbq68uCPSAOPu2LSa+bP3MHtVBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6469
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230118
X-Proofpoint-ORIG-GUID: AgDFDrhznlUG5g0mMOkh3QA2qwCPnJlu
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=69738e7b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=3pkepTAlydW79E1txPMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDExOCBTYWx0ZWRfX0RSMEaWum8/V
 AeftaM8cz5ntOYNjdU+Tmwe4qA0npUzvrNz7l4OUmYRYrNKcGIiVSooyjh3ebrmEEVWyy1XvoPs
 UuqLqx7GjjThV2Ed9IFxzVCvdLmrDl3/TwURT10U/rs6EcGpLUY2AVhzlxMxRns4TTnaHjnNf68
 GNTNGYL/3d1JVv2WhYsjbTF10snA+o9AYviqj08gTDULY37z/Q/VQ2y7r2fV4FiZ4phATJ4YUd9
 P2B+WDS9ciUdJ9MV9v6/TN7YmH7ALyuIBMg+vfesLoxxNm3PdirkURMJp3wbqc3H4GXmoZGuOLy
 x6gB5DTA1Zx56rfqZ+aFNyekXe9BaI64Uhi5zh1tq2HV8AOAJxHVhIycbQBRjLuQEVi4sB4lI8C
 IGBStvfG2P6b2Qv4De1axyRX9jefGF5z15E3Tr9TjBg8RhvPvfpb1bfSOGYzFeD/P4l0aap95JN
 S2e1VtD1/DW9bhLxyKw==
X-Proofpoint-GUID: AgDFDrhznlUG5g0mMOkh3QA2qwCPnJlu
X-Rspamd-Server: rspam11
X-Stat-Signature: rmybgsxd8wwn5wce9ah5omhe9hww6kap
X-Rspam-User: 
X-Rspamd-Queue-Id: 035CF140013
X-HE-Tag: 1769180805-865549
X-HE-Meta: U2FsdGVkX1/QQXHo//vW93w4Yz/tRUFieSh6h8Kni79pZF8zgFg56/VDe0tprituouBYX5pgCcsJJtE672N03q1qU7/9w96p1TZK9toHteeXW/2IRAzc92iBJfpHYl3BVbns23NPRW932LEOFGjrzmQFcR6Mva9O1eIzLFU2t4zQ08ABxxCnyg5xM1iHtQLbiXTaQYCfi7KrI+P0lkC0Iice1ZJTYBhaAO/nv99rc3rB4XzRCSVWiK3Is4ZE0usysHT2zFEUEiWb62xwh0M25vz/RgzFFj6ZOMN0jTSU4Yezj1gxNUf1CWp8Pi9vj0IBR+uZeyjq7uWMyAk+24/qqJ03ex4kxa6z9ETjT780EYPrzGB4nE/YpuUnwex7/U/I7H4ZnstoMaD8r7dKn52iN0qf2mFVjwRoWWL0HNISMuWMNJbsdKfpht7xsL1E3PB1W8X4gKNvHg4hvnT9YCSyzKEqHklU5v+2/QBLnJaP/v0KoacUC4BPYEQErXkei+1CsRFR5yeAgL1Vybyk8XMpeKzPBcEhyQphNL4URmUz2TqBAIwVncLhrw54VdxJQgHacLzMCx+tyq15rYXn5fiAoWdMWbwmFHfp39zsgG0e8NdrPRZU6++wKRGmFh51+FiEPIbxggwI/jI8CL/EQWLzqP3XITYEddemXKP1+ErbjslDJvw2HSebwS6tfiCVVVJuxc4IMAiG2f+d7lRJUTnWh00dOU8WgbCqhAwXZXx88L3HuUMIdHFUDiZXZmshgzgEFJa5Jgm8qwi8VLxVrJ3I3X5SpwNnqUscIgYo0rqfyJtefsJvpKb/C0rLwx5tuW6nISeY9FDcUWRW2w8+MKtREluelPjabHqJZWhxi+MsXXG1RQao46hAr+uxMz9BheJYTQ5/93+wVKAEpa1P2VRKn3yF1tr8HeeLwP+OLlezVWs5+PAiXOE4GfsUMw1DTMyCFfj9WhYyjPWj3kRDt4o
 4IdIVSmI
 +nsf1zct1HKmM3Ep4D0IyZq4nleYZG9IYaY/zgRjQ6mV5Pkkc9Tm5Uyt48Hw8hS50H9/hV8e6AMW0MrwiJ3lEfv2DWYxrgSCsprMh6LioARuELR9FqfhQoIj2ncjyOUM9liAq3JzAmlU5XJIocqtg1yMl7N3mL5brSAKFE/WpO/RpS139laMzoplAm9bEAcKEEYZNr2usH8HcKNwEF+IKgLeT477hYhJUXqHxFgIMjjs6OwmxFHh8Igmf2x42Ywc2tjji8DqtfFSiSSVvpNuiWw5pkzF9j8/c0bhf0FA/pBPWj4Fk5hIjZoQsAOAjqSK2LCtdQhWzyDbuEmqxwSKyS9/BZxlTPh9yfEfXEiuSWasb3Py1sDTByFd9dp8EhTcc4BX7voVC8y+LgZCmkIu7O4DVhXbzP6myv0rAnV6kqd1XY4ww6ZbaifWsiB5zsXz2c/YNFTgKmGGFVKffxPAw+E0bj0kNMAlb+f5G7kOet4kn7nqB7uSODXFdH4j+QU9uD+QUzNWf62rE4qIzIFLV1RsWCecuAJW/JPwwA5l3v8fAkLdsVOXc0/tfTMdeGZkC7PY2q6JvE2DZ5ssfWdZ7Wrl+dv/xgPioR3l1B6T/zCCYPJQLzvYbjK5K7Osz6vLcfvNUuXplvXruIWrnnPjFZOuJ3NiIVuc7kHJ+Xz4+EwGQSFHmyZobQwHSmyqB686RwhotztlPayNEQgVu1WSx4dMWNk+k6cityFLqpyIAWAk9IWSO/vOd/jrnwScbX2oMMzYt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry missed this before moving on to 3/10, responses below.

On Thu, Jan 22, 2026 at 09:28:05AM -0800, Suren Baghdasaryan wrote:
> On Thu, Jan 22, 2026 at 8:48 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> > On 1/22/26 14:01, Lorenzo Stoakes wrote:
> > > The possible vma->vm_refcnt values are confusing and vague, explain in
> > > detail what these can be in a comment describing the vma->vm_refcnt field
> > > and reference this comment in various places that read/write this field.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > Thanks, very useful. Forgive my nitpicks :) It's because it's tricky so best
> > try to be as precise as possible, I believe.
>
> Another thanks from me.

Ack

>
> >
> > > ---
> > >  include/linux/mm_types.h  | 39 +++++++++++++++++++++++++++++++++++++--
> > >  include/linux/mmap_lock.h |  7 +++++++
> > >  mm/mmap_lock.c            |  6 ++++++
> > >  3 files changed, 50 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > > index 94de392ed3c5..e5ee66f84d9a 100644
> > > --- a/include/linux/mm_types.h
> > > +++ b/include/linux/mm_types.h
> > > @@ -758,7 +758,8 @@ static inline struct anon_vma_name *anon_vma_name_alloc(const char *name)
> > >   * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate to
> > >   * vma_start_read() that the reference count should be left alone.
> > >   *
> > > - * Once the operation is complete, this value is subtracted from vma->vm_refcnt.
> > > + * See the comment describing vm_refcnt in vm_area_struct for details as to
> > > + * which values the VMA reference count can be.
> > >   */
> > >  #define VM_REFCNT_EXCLUDE_READERS_BIT        (30)
> > >  #define VM_REFCNT_EXCLUDE_READERS_FLAG       (1U << VM_REFCNT_EXCLUDE_READERS_BIT)
> > > @@ -989,7 +990,41 @@ struct vm_area_struct {
> > >       struct vma_numab_state *numab_state;    /* NUMA Balancing state */
> > >  #endif
> > >  #ifdef CONFIG_PER_VMA_LOCK
> > > -     /* Unstable RCU readers are allowed to read this. */
> > > +     /*
> > > +      * Used to keep track of the number of references taken by VMA read or
> > > +      * write locks. May have the VM_REFCNT_EXCLUDE_READERS_FLAG set
> >
> > I wonder about the "or write locks" part. The process of acquiring it uses
> > VM_REFCNT_EXCLUDE_READERS_FLAG but then the writer doesn't hold a 1
> > refcount? (the sentence could be read it way IMHO) It's vma being attached
> > that does, AFAIK?
>
> Yes, since there can be only one write-locker it only has to set
> VM_REFCNT_EXCLUDE_READERS_FLAG bit to announce its presence, without
> incrementing the refcount.

See reply to Vlastimil, I've reworked this to:

	 * Used to keep track of firstly, whether the VMA is attached, secondly,
	 * if attached, how many read locks are taken, and thirdly, if the
	 * VM_REFCNT_EXCLUDE_READERS_FLAG is set, whether any read locks held
	 * are currently in the process of being excluded.

>
> >
> > > +      * indicating that a thread has entered __vma_enter_locked() and is
> > > +      * waiting on any outstanding read locks to exit.
> > > +      *
> > > +      * This value can be equal to:
> > > +      *
> > > +      * 0 - Detached.
> >
> > Is it worth saying that readers can't increment the refcount?
>
> Yes, you mention that for VM_REFCNT_EXCLUDE_READERS_FLAG value. The
> same IMPORTANT notice applies here.

Yup already done as per reply to Vlastimil.

>
> >
> > > +      * 1 - Unlocked or write-locked.
> >
> > "Attached and either unlocked or write-locked." ?
>
> Agree. That's more specific.
> Should we also mention here that unlocked vs write-locked distinction
> is determined using the vm_lock_seq member?

Good idea. Have updated to:

	 * 1 - Attached and either unlocked or write-locked. Write locks are
	 * identified via __is_vma_write_locked() which checks for equality of
	 * vma->vm_lock_seq and mm->mm_lock_seq.

Note I felt it'd be distracting to say 'vma->vm_mm->mm_lock_seq.sequence' :)
mm->mm_lock_seq and hey go look at the function to see the gory details.

>
> >
> > (see how "write-locked" isn't reflected, I argued above)
> >
> > > +      *
> > > +      * >1, < VM_REFCNT_EXCLUDE_READERS_FLAG - Read-locked or (unlikely)
> > > +      * write-locked with other threads having temporarily incremented the
> > > +      * reference count prior to determining it is write-locked and
> > > +      * decrementing it again.
> >
> > Ack.
> >
> > > +      * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
> > > +      * __vma_exit_locked() completion which will decrement the reference
> > > +      * count to zero. IMPORTANT - at this stage no further readers can
> > > +      * increment the reference count. It can only be reduced.
> > > +      *
> > > +      * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - Either an attached VMA pending
> > > +      * __vma_exit_locked() completion which will decrement the reference
> > > +      * count to one, OR a detached VMA waiting on a single spurious reader
> > > +      * to decrement reference count. IMPORTANT - as above, no further
> > > +      * readers can increment the reference count.
> > > +      *
> > > +      * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - VMA is waiting on readers,
> >
> > "VMA is waiting" sounds weird? a thread might be, but VMA itself?
> > (similarly in the previous paragraph)
>
> Maybe "VMA in the process of being write-locked or detached, which got
> blocked due to the spurious readers that temporarily raised the
> refcount"?
>

Well no, because you might have legit read locks held that you're waiting on
right? That are not spurious? Can be a mix of spurious and legit (though
unlikely, since by then you'd hope the READ_ONCE() check would succeed, but hey
there's weird out-of-order arches out there).

As per reply to Vlastimil I updated it to:

	 * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either write-locking
	 * an attached VMA and has yet to invoke __vma_exit_locked(), OR a
	 * thread is detaching a VMA and is waiting on a single spurious reader
	 * in order to decrement the reference count. IMPORTANT - as above, no
	 * further readers can increment the reference count.
	 *
	 * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either
	 * write-locking or detaching a VMA is waiting on readers to
	 * exit. IMPORTANT - as above, no ruther readers can increment the
	 * reference count.

Thanks, Lorenzo

