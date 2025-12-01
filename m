Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74BB8D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 19:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7BA76B0095; Mon,  1 Dec 2025 14:16:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2BE36B00AD; Mon,  1 Dec 2025 14:16:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5406B00B1; Mon,  1 Dec 2025 14:16:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 937546B0095
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 14:16:42 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0564131F44
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 19:16:39 +0000 (UTC)
X-FDA: 84171858918.30.C15CE15
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4575A10000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 19:16:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U9o0GvaY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q8r2iplq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764616596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NDCTCfLuHr+aflf7hw6vum1xXZjqZpxo2n2W8v4h6dU=;
	b=i4HY3Q3Ds2TTcWq0rdMuFOzB6ofVg0zCOp9Bw4uMS6v5YgR6est4wiwIWhnUX5WbMUY1cM
	mDEjEZ4lZonxgJdIyDH6yDoZ4UD1NdQnpFNnJXzEwsAhizq3iqwRUMf/OD0xRJPhr9xXfq
	5Wn9YbaH1IV4cUgf8H6M3PsBNPNrQok=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U9o0GvaY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q8r2iplq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764616596; a=rsa-sha256;
	cv=pass;
	b=I4HXawlSzAB0e8PbMdM9VkR71dfobxHo8FyUxPW+HhRHYKKexwaa63+PTQaDNjfrBxsmHC
	x1O0K47BjOSJKYmY23nhTqhrMK7Q+Wfk0Td9g3xOb2IqyykdEMuajf0puRBtDFzVlYRCAE
	WsxGeoiErNjrCwIShISgAxjgno+2eQg=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1FgMhL2280125;
	Mon, 1 Dec 2025 19:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NDCTCfLuHr+aflf7hw6vum1xXZjqZpxo2n2W8v4h6dU=; b=
	U9o0GvaYeESNDyZFA4n5ObVGzo7W9cfqC6UJAhzwsyj30wONwomHFOpbCDETX8kR
	YR4vNCGDiRoXYDvK1ITKXKMl8lfj8dtnIC9bQPQW3CEzo5wH4HQcJuLzKMbPAifw
	QPU1/yz7XhdUH9n2kWav+WPIbKwgx6YCFaPb0lPC1/ObELlMprnX+q0Wysf3L1Lg
	AvhXcBYTsO84BfRDjzCa4RPi1/SwT3Hd6rn1T734gjAtHl1FUJ0fxN+cvflDUzO1
	dNAI4TznQCJBXcfUlDwmgAYE7SVJPuHqBrj3LtqyjtJUbRGggiUwffw4eVp7+eSq
	R41bzEbHCKXp1JHDisGJzg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as7f218ax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 19:16:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1IS9ME011886;
	Mon, 1 Dec 2025 19:16:25 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010062.outbound.protection.outlook.com [52.101.201.62])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9jdxu0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 19:16:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=opIAIHcnkPmVPjXcS4qUG3P4hCp37Df/XvjRs6MWzDyZzEX5DCXRyI4bLGQkZ9mpKC75dg69AkBshe54kmifxrwCbfNcfrbB2Qj/kHSbed+Sz8TZVgopqhVEbzTMxcfuES9QQB5p7v6Y/T3Z9Jn3SW0srdn57ifSV2hAw92/Nbnm+JxtuoQYJ+Zrx3BPQm/3Zrzwma6hc/AZQ0xNOdpQmUUrm03MT61iBiRdAyc1qToVV0qMrvGX3gY9/sSH8ih4+F4dbmdJqefSCWAJa/QYvdBELf4tKHmG14iC0dQKuqsphQH/DUiUSx+Fvcm194s0HKafX45f4CprTNy2GmpeNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDCTCfLuHr+aflf7hw6vum1xXZjqZpxo2n2W8v4h6dU=;
 b=u11Xys3b4RzLqUzzG2chI8091OvfQDcIJiSCUPT0fiVaPkblHgPdhuZiHGMGErqs8sOj2KlZx9qu1XCpkMn563BtPwTFqWKE4Noa1jwV+e7ZiPAv0x8TXA15zjvNowrD58GxOsulDdPVigAB6pj0lWVphc4Do8kO/pFNv/8ISg0Hfv0xtMGbtOcKhBixkDY0xC0H8+C4oF1+12X7ZvJL+cDB9VGO7+Cu4p8QxejWHcg74SUlXEInI5CPnGP0tuiiQQwaUXAKCv0EH7qJkpI9/GgI6z4+KONnGcMJ/gY1imykfCRWkIf1itWzCRJ96cMci3HQAGSqhOSkftdgPjAdKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDCTCfLuHr+aflf7hw6vum1xXZjqZpxo2n2W8v4h6dU=;
 b=Q8r2iplqugV5I2GrEY0+VYz14qJ4SuzQxPQvtVUwzjgSPW/hDB+bnbcBWMn3T8W1WjmcuNsFFWSsTeWc0dFmzCe5EixfIwv6qEFHPZI0EVnUq5pZoTeKpRejFmqYqJ5at+KM31UQ8ibXFlx6G7fVCx4KRDPKE5CdhjAjRadc5x4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4775.namprd10.prod.outlook.com (2603:10b6:510:38::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 19:16:22 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 19:16:22 +0000
Date: Tue, 2 Dec 2025 04:16:08 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: Mateusz Guzik <mjguzik@gmail.com>, Jan Kara <jack@suse.cz>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Dennis Zhou <dennis@kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/4] Optimize rss_stat initialization/teardown for
 single-threaded tasks
Message-ID: <aS3peFi9SqzcOoEd@hyeyoo>
References: <20251127233635.4170047-1-krisman@suse.de>
 <f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
 <yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
 <CAGudoHEyX1gdwG_MVf-M2KMHBE1Juo6VbfSyp3rbXoS+5JaNtw@mail.gmail.com>
 <877bv6i5ts.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877bv6i5ts.fsf@mailhost.krisman.be>
X-ClientProxiedBy: SE2P216CA0126.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4775:EE_
X-MS-Office365-Filtering-Correlation-Id: 713f2e05-f184-49e9-76bb-08de310e1d28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V2IrME8xYTRlL0gvWHZMd1AvK0dvbVFoSjA0cXdjdzhCbHBITFB6bEZtSmk2?=
 =?utf-8?B?QmR3R1FSaUtTSldJSVJqN1M1SUs2RmpHRDJsWE54QTFSNVpzbDB0NG5TK012?=
 =?utf-8?B?NHdLVWJjeHJUbVp1MGljZndPZ1ZFbWt3Q2hTNjhEbVVEVVliRVV4UUdDNVZv?=
 =?utf-8?B?UTlCNkNWRndsd1crd2tDVVY0d0xNeEFOUnE4ZUs5VE16UzRoZGNsdHV6cVNj?=
 =?utf-8?B?U1V2U3dGZUJ2VGlGVHpJUzBFQ2hWemtkUkF6NTNvUjRBQWhDSU1YSnN6MCtm?=
 =?utf-8?B?T1M0aHpiUXdyRWJvdmJZRStwNnpNSG9TVmdLZzFwdkV0czNTa0s2UE4wL1h1?=
 =?utf-8?B?ZEJNUkNTTmVRRUFCajdNUkF0MHFEaVRRL2EvRVFhYVM1SjJWbUw3b0UyRXBt?=
 =?utf-8?B?NnZpd1c2T04vVVRXdGNlNnV4cUpWUTlIb0I4L0svU2x0dHM2L2NDZVZLSHhr?=
 =?utf-8?B?YmxLMXcrN1BRTlpCZDNlSi92MU9WbmNRWXVKNUtIeFppUGlBZE5wOWY0OVBY?=
 =?utf-8?B?Wi9DN3RsSVg0MkcvRkFvTHpqTktRdTVaeE9jQmNQMTZQQnhvUkNPY2ZBQ3hm?=
 =?utf-8?B?a0pxSmRKeFg4ajlSNDdIMjNpaHU0UnFwSGYxSkdkaE05M2k1VGpvOEtuYk9u?=
 =?utf-8?B?LzhFTDRWQjVXaHF3VlZ2ZW9UbFBVbTJmZFZJRWhPZjI4OFlCNFhxTVMrL2Rm?=
 =?utf-8?B?Q2xtWG5VYnhRdmkzTDhrN0V4dUY5S3pCTzk4NVoxQ2ErYjI2T21NZTlrNUVv?=
 =?utf-8?B?MkxyVzhxS0tjdlZxMFMxQWJjTnRoLysxdU16UW9BeEtCY2tEVHJXdWlyUmM5?=
 =?utf-8?B?WTErM1YzUDFuZE5pOFZ6WC9HUldGYlhJMmttNmYzTWZZaVZOSG5xMVNDZ3k0?=
 =?utf-8?B?QSswRXByb0FNbTlyTCtGSHVVcW1nOHpzSUJKUjFWd1ZZcXVWM1FHVzU0Qk5E?=
 =?utf-8?B?QXh6cG9VL3VJa2dkSUhteG8rOWJURHMwd0FlYVpUNitmT2lXUGVPSkJ6OGxq?=
 =?utf-8?B?UEdWRnZyL01wN0V5T0JiZE9JeXkxSmh0QmlwZ3ZBU2dKZm90a1BWbVdocFdF?=
 =?utf-8?B?bVUyTTdlQlpyWFlJS2o4TUNaUHVjUk1NRDJCdTJseUsvb3BqTGZ0ZHZOTFJ1?=
 =?utf-8?B?N0E4Z2xaOWlpTzNRRjBXMU15TnB1Q3N4OU1HRWsvb21WS3JqR2dRR3ZyOHU4?=
 =?utf-8?B?SzhxY2NYSElsNURnQnB0cWlpN2QwNEdYcjZROVdOZFVSbDlmVjRmQ3hoNFYv?=
 =?utf-8?B?Qm1MYUV2cE1JM2U4ZkJLM1NaVWlHaWN6MmY0MTBjZVJ0T0ROb2JVdVRzNFhH?=
 =?utf-8?B?ZHRHSHhraTlZY2FzS1grVDU4ZVA4c2FhbUl2Tm9vc0FzZ2h1LzhLZjBwK2V6?=
 =?utf-8?B?MmlUL29haWtNS1VNeTNYT1RodFhlZURNbFNHVW5wRDdQMDFpeFBySEZPRjFV?=
 =?utf-8?B?aFBCMG13eGtiQXlKcnhEa1pkVzJtNzV0QkJ2NDJGNVJiMUwrV3hEcWxIZWVm?=
 =?utf-8?B?SXBxR21wOXUraFBYRXIxM3k3QktQUmFZZmdFOUlJSkxMckNYdk1laGYwMWE0?=
 =?utf-8?B?YWZaSmV4WGpucHo3VVNOTnBta3Fpd0cyRDVmYXdHVnE4VEJxOFIxeU45L0dD?=
 =?utf-8?B?S1NPdUY3SDJ4VDRHT1lQcFZIQUJZUmpqVnpTVDBzSElpdGRJWUFjcjg1bWpQ?=
 =?utf-8?B?UWFMeUJzbDhiME5tNXJkSkxBY3dvVmZGNTg3cjZ4bW9WdEtTaUxnb3RIRTdF?=
 =?utf-8?B?RXhiWmJHVFZYUkFBazAwM0pOTXVBT1ZQYjVzdGJRa0NiRWdCNXB6d0h5LzVX?=
 =?utf-8?B?Q20vcXdYNElremJoZC93T0o0Tlk5ck55NmwwV0x5TktVdXNEMEQzaGx4SUIr?=
 =?utf-8?B?c3M5SFhUbE10Q2ZpajdEMWRZY0dvb2FxUGMyODFCZXJweENFcnhxZk5UUHBk?=
 =?utf-8?Q?Oiipg4/nPkyMRjC+Xxg9BxEPLAx190G2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjhXWWtSMU15U2tpVlpKRzZ5emtQTHJaQkdPVUpVbTZ3N2w4ZkRaR2t5ejF6?=
 =?utf-8?B?VkRSd3M4ZkxDN2dEa0p4UHRNY1NPQjZJL0JFWFNJSkRLYnhoZGF6UjVHQXRv?=
 =?utf-8?B?VityMFFkYnY1amREV01TRmdqbU5nTWNhMVNSS1YyS2thUmtrNmhaa0VacUd4?=
 =?utf-8?B?RnoybVJaSG5OaXRwQ1ZPVmM2MzY4eUFmMTRqNEEvTDVmNWhjbkpWU3pYSGpq?=
 =?utf-8?B?N0FjWkI2SlptYlBXK1kyNWt5TUNpNzlNZjZCbzVoSDBKKzJ0TGxCWGhSejRz?=
 =?utf-8?B?UkdDQkFROGJDWDhPRWhjTCtjRmthL29HdTdBRmV2Tk5nUjlCRkwrbVg0MGNH?=
 =?utf-8?B?eExXWkdJbUNwRll5YUZQQnUrSVBIL0xKT2NWekFKUCttS3FJREowVmZ2cUlu?=
 =?utf-8?B?alBCVTFKeUg5TXBUL3YxeEdrdmwwZXNsTXpJQWd0OGpmaWtNc0w1R2dRRGx5?=
 =?utf-8?B?RG5HQ3FJakh6Ynd6bzhBRmYrZmEva0hIckN0aWc0aE8xQmhsdHZZdi81dU8z?=
 =?utf-8?B?bEdSVVkzVlpFSVFNdjhNVXVTSW1scDNTYmJGNEtKT3hPQjBFRVBIeE1WSVpk?=
 =?utf-8?B?SHpYZ0ZDU0s4ck5UQlpOWjQ2UUlRc0o4bHc2WkpicWErcGtpOTZPQTU5aEdZ?=
 =?utf-8?B?L2oycFFmdEErQjM2M21yZVhXRDNWWWRUazgxbTBnWHNmUTJHN1Q0WmFtL3Bh?=
 =?utf-8?B?alR0KzJFWEhiWThsUXlhR0FmYXVWb240SDByTE9CakhkU015clU5V1l5amdC?=
 =?utf-8?B?Qlp5WFIva2EwbjVxRUxPYlRZaUQvNS9mU1NpakJkYWE4Qkd2Qk1PRTAyUlQ0?=
 =?utf-8?B?Z2dPUjVWVEJiU1JjMVJEZGJkTm1XUFZoQ05ja1VtTkxzYjByRmd6NWRreHBP?=
 =?utf-8?B?bi8xa09YSU9kUWZzRDNjeWlmdDF1V1REU24xUlFNcWUyM2hWVXgyajE4RWRr?=
 =?utf-8?B?SFMrYnZ6UFF3WDBKZEE0SUdlb0pMRjBHRHZkTG9XbkVWQStRU1pjRk9FTlFF?=
 =?utf-8?B?M0h5cllMc3IrSVNSamdrRnE2SVVwYlozdC9Tb0RpMlJMWWlzTzFIcGl1NHI5?=
 =?utf-8?B?MFJmVU9MbDdtcXVVdThYRlFWblp1NHZoa3VxdXpGNHRtZmZkUm5zT2luenVW?=
 =?utf-8?B?Y3hFUmpTc2lVZW0ycFltK0J2b2prUmRQWGdzb3JROXRpSmVGSFNON3lCYWlx?=
 =?utf-8?B?NVBQdlVoblJZZDh3NVhRYnVHL0VQK3B0QUNVZkVtT1Q1UVpvZWtaY0NRdm1z?=
 =?utf-8?B?Q1FDQjRCQUJZYjloNGJRMnVYU1gzcjRwV1JldjN6RVhaMkN1UFRZZzNBT3V5?=
 =?utf-8?B?bXBWL2FraVordTZjUEs1WjRnMFFrendSZnROUERJYWk1bVpqTitVUStuY1ZL?=
 =?utf-8?B?Wm0rY3d5VnltYkJlYjlvdmRjNWVFOHo3aDBsbXRrMkJzazZSR1R0c1JzU0Yz?=
 =?utf-8?B?Y1pMYS9WRFFaSC92eUNPUCttek5jYWR1NlZuSkk5ZjF5UDlkSW5scmJTVmVk?=
 =?utf-8?B?YXBaQnc4TDlmMnRyV2E1VHluVGV3VkFSTXpxc21ZUmhwKzEvNjBIOUp5dFdl?=
 =?utf-8?B?eHF5eTVsV1ZvcGhyNTdVN0szRm8xbEcvMnhUR01Ddkg2WEFBbXJZUzZMVlZL?=
 =?utf-8?B?YUIwcFV5d0VmVnlBVkNlWG1HWjJhemozcjFhZGsrMzE1YUYzSGFMQlo1RWVi?=
 =?utf-8?B?Ui82S3JKZDI0ZWtCbGNlY2h6QVovTjdYNm42a3oveVVPU2tsWTFMdmQ4Nmg2?=
 =?utf-8?B?VHBzN1p1OXpQRG5tL0g5LzlYUHZCMHBMZmthYTA5QjdqbXpQbTVqakJDeERi?=
 =?utf-8?B?aTd3UDBjSlg2aHdXZ0tPSDFTdkIrNlAwMnY5cVBzbE5aeDQ1YUhDUWxac1px?=
 =?utf-8?B?YTE5Qmw1NS92aFBLeDFhU2E3QVBvNEp5N0RQMDJKemo4dGxCVzZwNUhCSUFI?=
 =?utf-8?B?SGdsL1lhT2dPY0dQVVkxS3RaRGk2MEZBWkY2RmYrbUY5bWFqdU5YOXBhbXpo?=
 =?utf-8?B?VitYVUFPcWRRUCtLZFR0SVZkY0h4STdQUXVXS2ErWlpnd2pQcmZ6cG05NWV4?=
 =?utf-8?B?S3h1RG5XeHJ0MVJvSjhDOHRSamRkMWhvY0p2Z00rSFc5VWVEUmNPMnlWdFZw?=
 =?utf-8?Q?H/vIYeXaAw8RdonQx8OrQMdrL?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N3P7WnOmT56B2zyD7urj6/Dpi+k5a6HlsH4Kboe1QrGsuclI2lNrPOa8xrKOv/2Yt5U5eHAHV7AX+Wc3v2F+oy9nrL7R+56vLF9YcoVtL1k+SwME1HnxM3UEJEGwrXtLXesUg5VtNA6C2l+0z3RjBmTaDO1gDnx/9dsxkucfPIuJ+lesXnumrQ74VcdGpQhmUuVajWThIfWHEt8ctNUeh7o42n1h3uT4afZrU+1U2aS3HRL48iMV3byTFwvbFZauqd8JO61YMmqFSFMAubxfIXuGMvmsYQXAy/tF2qVPe9es+B+oGKtTNg17ETgncJZEJv3F57e5CxVBi2qFaD7vp3Y3wvOrlnX35ZSXM7ecZ0fSjI/qUVu2AAEAVM3WzUWghZMsM95uoW6ZqKMj4G2lsYpnD2bSUk4DoeSXIGTU7PF4R0j1eBNDA2W2FjiZtBCv7d6T3EWSK4W0WSnTvmwV05r0h/Q2iP2VRChtQJlxh7RIq2PyVBRXL7uWC6gM++CKUWnUcLXWrgJvDMiP+wPlG2DFgLlxTQBn/gxfJPHjLHXM30x5A4mbkciKMwCSg7g0deGqTzpfBTMmkVYvbIvYwyoBOj79aWLdrKdOYAJJynQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 713f2e05-f184-49e9-76bb-08de310e1d28
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 19:16:22.5581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJuNIb6WAG0CuRHLrmWOqTxoVQqLdW0jD1AUaOmgIDp2JuKABEl7ByxbqHlq7Rg3V7mGcQrlLaUzANRooFlDNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4775
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=651 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512010156
X-Authority-Analysis: v=2.4 cv=QMplhwLL c=1 sm=1 tr=0 ts=692de98b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=4twvK0-3165IkGuM8IgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12099
X-Proofpoint-ORIG-GUID: GRYu9uZJHvSspvzPUpt5VjrKFD4XMEwM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDE1NyBTYWx0ZWRfX1Ydnt8CcgRBu
 orqIiUU1qmqRnxJuTsqXu03hGMaA9ppWh6RNi1TtTM1n2bQZ3ET04gbMk/brODcdvTlt0d1q2MT
 Y/f1ZiY/2PjMnCJ9TJ8g2NnqTyMacNx6J6MLlFuL4aitthsTLwt60QjqienhAddYaGjdUtyFcVs
 RZPXRlKug6toG9hDk/NXC64Uu2W+8dLthRB5WfVXljjua7Unkz54tI1iiYl1Nk1BcYftWWTPc+c
 5t5xxpWdYN2lUY/WengFO8LA8FlfEcLunUIWi3zd3Z5knTwMQkpp5Kvh//AUwQf5iW497V7vqKU
 jTU9uWPDm5R++haV9kunkprkJq8OLzhfZGUEbmLY2qVl+1RmHdoyI44VaPFp1TBwlCucH6fpujA
 v4DXGTxux0EtQN6epDbC5OqDYaFDVHle6t6ex4dYJoXopQGA8wQ=
X-Proofpoint-GUID: GRYu9uZJHvSspvzPUpt5VjrKFD4XMEwM
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4575A10000D
X-Stat-Signature: xd66qxb3w4gt5wcbo4sk9p3816i7rkor
X-Rspam-User: 
X-HE-Tag: 1764616596-779052
X-HE-Meta: U2FsdGVkX1/peqQcQiHY68nOwa74k+B5JycyBitiUZciYoLu3R5l3UviQfiGIZ+CJkWvBp6PZeFf8+BOtXGwBVagw5gOKMynhHRe6XVTFUOJN04E8ZQHGELUhvVwnIhdj/3Z2Y2pna699QYhccRLXOexOvloGA15CyqSA/hMDcAhXsV/urcO3rsjQ1yrRlEyAkPOcp1RG+3yKwFIVtXCMPgJ6ekuOI+ClD4S4zCNh8S3sdd+I5BZqzo9GRSu8vY2wWKAHb5C1JGF58nRq2572uQQA8jVBOHCl9dx4j9iE7nEw6Rpi4UUiKCXdzF980Yg/CpLgh0p0SWjkpKYiiVZ948MZ9YLLA7oLIAYLgF4D5ox4X/RjO3qwsXpB+p9ZDBVkQHnoSr+z6McKc8slk0mW3G0gWvMcoL47ytmUTkznVg9qDZZiA1HBumfAjVFu3U+S5kCMC9GHT4EAUnRNpaBEVwvGVOvf5SiOF+pJWN2w1jl0ouy03CGrmwpe5VSmiAXGUKhie274+hut+EwBhPbnuyYsP3w7qhWMFwCjoR8fFao0EdjaOs3PqQzytWDCpQ+8l9PAAYYfcL9sm655wwm1RpNDgLolndkBl9BKDZ5xPvYk3h81G/pC81fzXmhpXKXg696J0hcKUeeOCgn+LwCeNRB4284p9+sU48qlhzJ6IEV5vWDRwinfKoO3tlek4kNv4SWMDA8m1+DZ5SDggeqUERXamwX85PaDcx7F+rpxI05TdcuHFDZo6sYPz8WUrGhSn0cNOZFMLW6mA0q5EezWx7upAikrEfl4bsiYV1WatzBZbZWgHzVKD+KPjFXTg895nDjkfg2TqeQtNxBG+7e8YLchyzWr6pc+S/1mGuoUuyXBbKF4r+WE6V6m1y4oZsgadL5JII7SdBhWhogTFWVR06Sl1EisfT10527ycSKEvQ0p5ORDwvG+m+3GrZsDoAtsvEiRtUJ2+ALpVgTwfM
 iOTyZl9t
 HkThJNI2o/j5PHjLd8D6IherybkDo2zH+G1MLPV1c6vOS6bBOjlTZSTruAMnD4Y51+xfpmgMB4wREMY/Bd6rMcB63rm3eQQPXm8DYMKKxNDELEYdvX37mnysJluliTNemjNUUU3djWjm5g/kyjZ0otrLVrJKfZ8eC4Lch+cU6o68JBKhkvlhX/TfYDy5cboEPQWw1t/A1xRkbktVYYDfISMwEQ/Ko/c58K2Wv5Ca7YcWV6h1o+pHvOU4s49XhqdnVQHvZYbusZJW8OT6D+gkgmxGJBFJjx+zBO94sXM8tog4p1J6+sxHWLXbQCGIUJIvA2GV19dwY/MSaHAnLGepzt+gmAc5/vh3bj7w8/STH8pMTkm/uBhxCifINW+Ksiz+LX/hEg9jkcsX3YjYyBwmkHuVFGecEWlYSicjNfs+mA8hDYnLUUPlAsk4pzayez13DxrAiiU/GXIiutTHyMKXVdQ863dYy9s3JRIViG0WtOhVh6GPw+dqPfnYybCtbsGusY24O9/ZovDunDXdklSDf/1FQ/XvU5xAzPR5TOJW0w6QH3HmaeW5qzofMjfbh1P0auocqkzPKDnyUGbQOt2Sf9khJ+wED1OkR21x9LcVMcVsq1PdIfixnq+dpDOURxatFslx6hX77avyQxk3mSfsIY3ASXZd/jBh9G2CCSkKqjcGePAyxZi5J0LoIIJdpR6yGoGp3f6SUb5Q7EZ/aA7J2euA/9jq92fS7ZhnvcPZbOVbngPzmQHLV2/oVVctcKuf4mmtp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 10:23:43AM -0500, Gabriel Krisman Bertazi wrote:
> Mateusz Guzik <mjguzik@gmail.com> writes:
> 
> > On Fri, Nov 28, 2025 at 9:10 PM Jan Kara <jack@suse.cz> wrote:
> >> On Fri 28-11-25 08:30:08, Mathieu Desnoyers wrote:
> >> > What would really reduce memory allocation overhead on fork
> >> > is to move all those fields into a top level
> >> > "struct mm_percpu_struct" as a first step. This would
> >> > merge 3 per-cpu allocations into one when forking a new
> >> > task.
> >> >
> >> > Then the second step is to create a mm_percpu_struct
> >> > cache to bypass the per-cpu allocator.
> >> >
> >> > I suspect that by doing just that we'd get most of the
> >> > performance benefits provided by the single-threaded special-case
> >> > proposed here.
> >>
> >> I don't think so. Because in the profiles I have been doing for these
> >> loads the biggest cost wasn't actually the per-cpu allocation itself but
> >> the cost of zeroing the allocated counter for many CPUs (and then the
> >> counter summarization on exit) and you're not going to get rid of that with
> >> just reshuffling per-cpu fields and adding slab allocator in front.
> >>
> 
> Hi Mateusz,
> 
> > The major claims (by me anyway) are:
> > 1. single-threaded operation for fork + exec suffers avoidable
> > overhead even without the rss counter problem, which are tractable
> > with the same kind of thing which would sort out the multi-threaded
> > problem
> 
> Agreed, there are more issues in the fork/exec path than just the
> rss_stat.  The rss_stat performance is particularly relevant to us,
> though, because it is a clear regression for single-threaded introduced
> in 6.2.
> 
> I took the time to test the slab constructor approach with the
> /sbin/true microbenchmark.  I've seen only 2% gain on that tight loop in
> the 80c machine, which, granted, is an artificial benchmark, but still a
> good stressor of the single-threaded case.  With this patchset, I
> reported 6% improvement, getting it close to the performance before the
> pcpu rss_stats introduction.

Hi Gabriel,

I don't want to argue which approach is better, but just wanted to
mention that maybe this is not a fair comparison because we can (almost)
eliminate initialization cost with slab ctor & dtor pair. As Mateusz
pointed out, under normal conditions, we know that the sum of
each rss_stat counter is zero when it's freed.

That is what slab constructor is for; if we know that certain fields of
a type are freed in a particular state, then we only need to initialize
them once in the constructor when the object is first created, and no
initialization is needed for subsequent allocations.

We couldn't use slab constructor to do this because percpu memory is not
allocated when it's called, but with ctor/dtor pair we can do this.

> This is expected, as avoiding the pcpu
> allocation and initialization all together for the single-threaded case,
> where it is not necessary, will always be better than speeding up the
> allocation (even though that a worthwhile effort itself, as Mathieu
> pointed out).

-- 
Cheers,
Harry / Hyeonggon

