Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D1CDD74EFF
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 16:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE1CA6B0512; Fri, 23 Jan 2026 11:34:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6EC16B0514; Fri, 23 Jan 2026 11:34:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5C86B0515; Fri, 23 Jan 2026 11:34:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A981D6B0512
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 11:34:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5555413AE8E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:34:06 +0000 (UTC)
X-FDA: 84363775692.30.7CAA787
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 24991C000F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:34:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EWo1xl5r;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="rP/O2NMn";
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769186043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iFd9hL7D8LJg1Er3CfDOKm1zMi25bzZ0oSokj0uwo30=;
	b=gQ4VXzmfORAwmnzRMLyvZMql8KvjpOCxcRGyFZAJxDdyzr4ljYV5p0E3AgB1is5oxn0xGd
	NyIYmIBNjMh02+wvEnrmsuW5nW3vPVrOuO3FjBTptUw37Oz/vH12+jqJB2sRsRl87btTf3
	Uc/NPtEoyCVPzNuaDxq8ncNCpO8gqVY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EWo1xl5r;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="rP/O2NMn";
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769186043; a=rsa-sha256;
	cv=pass;
	b=Z67CEdHs0k20ZRQeq0LIGMN6YPNCnmr/UBxoPQpRgYolZSBvkXH3jOoAEBqbzythGxhih6
	5c1O9lN9c826DCrEnH9xXY0UaXQKsSVuIciDlVaBNX8kRsjNF9yoTqaNl9sRZQatAOjkL0
	p6R3faRcgczBNDTivbzkF0XukphQ2s0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NDgqfF2271091;
	Fri, 23 Jan 2026 16:33:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iFd9hL7D8LJg1Er3CfDOKm1zMi25bzZ0oSokj0uwo30=; b=
	EWo1xl5r6jgzBV+YIRnnkiXQsLe/hQ52WTnVpRt3Mf+OnX1EJinJDtCN1JH5Pz3c
	ZcPipHulHn+k6T4ZFDZLOIN6TMVswrG2SnvtgD1kQz2dcLZSAp91m+MDqiUld5aJ
	AjK6IpzR+7lM/0WK92ve7/2MUK0fQ34EUlWvq5838coIUgKH8Cir5xm90KgxTb41
	LI6iEQuFlNV5FgC6LtJ7ag1hwakj5t1wEitfggA6wUIQmPE86JOGhUuz2tQJplPZ
	dRfLOsk0QERswPd1eTXwBUB1yj6qBqnWEwbZDnECuPWOSIXHQb5Utf0cCYo5BHGf
	dzuDWd/dmgtK+WUeTGTWvg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9tt0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 16:33:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NFaFZp035786;
	Fri, 23 Jan 2026 16:33:50 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010058.outbound.protection.outlook.com [52.101.56.58])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bux4ydqmf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 16:33:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cfMcrcsP9JIqh73Z5ivYdxVVbHeUehWXIwX52e+t69Cg7nx+TF3gvAD63nlZ2adVKlA+V8sLEYwGxNo+tQnjaUhOsIhxdiqlMj2p05/5gD+rQBpySMR6c9o1rE2WhcBC0FbSj0Ysf7P+oZywFPMDpcQjJowS6bySSvJQI2oOFVZMAtpepfSDbVGZyKfcFJALlEP+Oy9cUDnu43Jlv2iynjoNbLwr6UwRmavi1BEjelWYapsLO2AztPDipCUxqVvoAZ4OSTtfkV1FlufUhO/b/sQW1N5Jt1FYv6spJpcaoRojdQWerDUMOBxoLAVnwJWj72SzHPqhxLL5tXcBXR8Z9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iFd9hL7D8LJg1Er3CfDOKm1zMi25bzZ0oSokj0uwo30=;
 b=GhtPwehdzUs8/8w5YV2JPuDI/ryUBokJ3PmYXPPbK1m9eQAWDIs7vwFEejOuDxpryJYfXLC9VhrKKHBrSlr9oT0V1SAxz+VRWAueo440R+HTf32WaLTsbkn/xpaWT2o+2sBjafUT7c81JUVY65+jX+cyc0HDLdsmrDn2kkWfEUVncCiCejN9mXBSmBRQ/U0uk4QtWPm8qDhQYH+3IRj6PP8DXr9OtWUmjzjPNKp190JYonwqRvd2yPDvPuNC9n4qgkwplngepnfjoe1Sta1mn9GV+I0C6WiFFWXYnebmANLJBHVQ9Hf0GjPmYajWnuB2K0ESbQBOgSujzTk3cv/JGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFd9hL7D8LJg1Er3CfDOKm1zMi25bzZ0oSokj0uwo30=;
 b=rP/O2NMn3PFsyRnczGp9WmfVTC2CVt9U8tO5DJ4ryOpVuDcmzIeFupQH3rmlY74/iBKQgfqn4/wUqDwADhKvu2iEqgL4SKhzprwblmJOeewRCpKHXbO9t5JV2ud7eHZ+LQ3LIQ40LUK6KH1w1QNGDMHFJqWRJjcs/PPgZtYLvps=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS3PR10MB997727.namprd10.prod.outlook.com (2603:10b6:8:348::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 16:33:29 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 16:33:29 +0000
Date: Fri, 23 Jan 2026 16:33:32 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 06/10] mm/vma: clean up __vma_enter/exit_locked()
Message-ID: <bdfadd8d-69b6-4d6d-9144-deae8eca9d92@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <f1981963e3c9421b6ffef19f15d87953895cd0b5.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpFFW_tcHPMtryoVcSKigEGZxfn3Bz=8BUtrJj8kgEWDJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFFW_tcHPMtryoVcSKigEGZxfn3Bz=8BUtrJj8kgEWDJA@mail.gmail.com>
X-ClientProxiedBy: LNXP265CA0043.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::31) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS3PR10MB997727:EE_
X-MS-Office365-Filtering-Correlation-Id: d4aabe5b-494d-44bb-5a93-08de5a9d23ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEhxQkdFUVdCS1dVTlJZWC9jcEYzdW9UUXZyNUFBYXQ1NEEzNE5CSHBVVnFq?=
 =?utf-8?B?eklnTkYvVlVHOG5uZjZRc2tTaEFCMXRMMFI4aDBrVTBIOGF1aWdiSkEwOStv?=
 =?utf-8?B?ckR6VkZmeWo4WDl5U25STmN0aXo5ZGkvTUJhY05DQ29KZnp0WHVvWUlteGFT?=
 =?utf-8?B?aTFsWFgzVW9EWU96NkZhaTBCQm4wSGpuMFBoOEpRMjRtNEFkMUZwdVA5MnNX?=
 =?utf-8?B?SHBvR3VXejJyUWxzM2dIMGF6bkRybVJJR1hTNC82S2NOUnJGM3dIWjdjeEZ5?=
 =?utf-8?B?d3BPN0dtblNURFhJbTdxN0RJV241ZTRXWFowWUljM1hseWdEeEswVzJMV2ZM?=
 =?utf-8?B?SllsZStrUjhKOE45WVJacTlZRnQzVFFqcDlpVTZxV0hmNmROTXl5Z1dwUE8r?=
 =?utf-8?B?M282TEZJdEYrWHVZV2Vaa3pwODdYYXZWVFZ3aW9VL010Q0ZTNldaSGl5NXQ4?=
 =?utf-8?B?M050TDNldzRQNHZUcDFsZERDZzZJb0thRllJTEthTDF5a3kxcEZaMFhVLzBu?=
 =?utf-8?B?N0JGcTU3TDVJTlpNVFY5RGVDM2xVbmRtTjJYaEVtNHBtUmJJV1p5bDBQMzFH?=
 =?utf-8?B?eFI1MlpLNUpmekM3aEM0RU5BR3R0OW5qUTlYWU5qOTBYazI4SW9BL3Jhb2FF?=
 =?utf-8?B?NUVCMGZlTnowa0hpWkJNWFdPZ1J6d2dmR3N0VG1MSSsvZ2hjbWZkeCtxU3ZJ?=
 =?utf-8?B?YXVIUWNSN0l4c2xQdTJBbmRyT2M1dUt0d2pGSEJLWFVGeE1abkUwbTBMaG91?=
 =?utf-8?B?K0pVUDdzN2pRZ1RLTVpiQzBtWXc5N1BvcXJJc0RoUDlUc055dWgwR3Fha0cx?=
 =?utf-8?B?eFE1U0dmck85WmFCeVl0eGV6elVHcnpwS20xTnBIZmlMNGUrRmRmZWVWTHNU?=
 =?utf-8?B?eGd4QVY0TytVMk56VDErYm1YNHlTUWpPcHdTS3FRem9oWWk2UCtleGJmTDIy?=
 =?utf-8?B?cjJpMitPeVBadVlLNTZYRVBUb3cxYnI1cEZXeTMrblNLM1FWWGtLbmhQMWJi?=
 =?utf-8?B?U0xEbm9jZHpaWm51K2J6QmJiNEQ5K1g3SWwwYU0zSXpORHdxRnJqcVZBUEp1?=
 =?utf-8?B?bHRuUHRqRFVkOXhSaG1VMTZNWWh6bGZqVlFUMkpjQkVGQ2YrLzRkanRLWkJv?=
 =?utf-8?B?WkxGdVN6WExyNmRQc2ZHWUg2cEF0emtiZEpMWlRzWXp4bVBlbEZTcXhYSWh3?=
 =?utf-8?B?ei95THNlMHVkTzljNlhoWUoveU1saEpHVG1XZVdac3hGTjFDbWR1M1dlSGVT?=
 =?utf-8?B?MEwxZzRXZmN6OUo4dmlQYVQ3QVZxQjZRTVVkZEFHMGQrYi9aWFpCKzJoMWsw?=
 =?utf-8?B?SG9SYWZIT0V3ZjJjSUl5WVlobU14dXZPVVlLUVJKYWVOTjJHeG9ka2NzdUFH?=
 =?utf-8?B?dHMyVXlEQTZwYys0dFBYYWNXRUd5ZkpTeGxQNWRkT1FWODJGV2dxNUpYSXpi?=
 =?utf-8?B?NGJJbXUyMWRnaEJCNGhNaTZiV2EwK1FvdVRSMFl1VU1sYXRwZ0hHU20wNGFO?=
 =?utf-8?B?NVhUN1ZjSEJCWUZseS9sL2hLYmpNbXMxRTlEMUFaOWJPdU1wZE5mUzdqYUZS?=
 =?utf-8?B?aHRIL3BCbWMzTUMvajBqdUd1NjI0Sm9sNE8zcmtkVUl0eG1VWTFDZEFSM0s0?=
 =?utf-8?B?Z3ltRlRraHprK2dVdzZVMTdaUHZ2R2tUWDdndkg4QnJOR09pbXpHTVFXQmxz?=
 =?utf-8?B?R0NOY1ZzMGhVSU5TdTBOL2JzS0svUDV4SjczQWhpQUhWNCthbmR3S1dJb09u?=
 =?utf-8?B?ODFrZzA5YmJOS0dqYkUyNzZUc3c2a0RsYzFWeUZ3eWtDTndJZ204Sk1mcEU2?=
 =?utf-8?B?YnRhcnVIaHBPMWlTNUZZRFozb3FTdE53dVNPL3NqRmxIc1ltUlZ5bGx0cElx?=
 =?utf-8?B?cnc2eStLNXpnYUdXSnVBR0hTQXZUeTI4VVFWN2pVekUvT3AzNDJDTU53T2RE?=
 =?utf-8?B?cW53MXJ1ZTVtS01vK3A5d29rZlVtWCs2dEhFaFhqUU1vSkdoUUZ3YjYzUGQv?=
 =?utf-8?B?MmR5ZjdKdTU0clhBZ0tsY2ZkWFk5SFVBaGVrK1lYS2ZnQTFJWDZaQ3FXL0RM?=
 =?utf-8?B?NHhJTXVxUlZOY05yQnkyZVFDVXRUUUN6MUZWNmgxUTViaDllamMrYVNldGxC?=
 =?utf-8?Q?/j9U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2J4NktVcHFWZmc0VVNLRUp0UDZmRnlVWmFqSjBRVWU4elZXMlR3dDdMWWh2?=
 =?utf-8?B?RWtBMnAwZmQvY29YWUphKzREc3JTNm4zbUVQalhrbEY0R2ZTdWt0dmljcmZ1?=
 =?utf-8?B?bS9KUEFpTS90ZlAyZ1dhdklSZDNjdEEzVHI0OUFBY0xIMWltamVQTmlhZ1F0?=
 =?utf-8?B?aHZvTXBTa1Z3NDRCYjB4ekU4K010bjlKaXdOajRDdXFCNmVVdEsvNnY5UmNy?=
 =?utf-8?B?OUNmdk9WSlc3ZkZ3S05HMnRIRWhmMTVmczIxVGxqVlNyVGpKVmdCK0VkOWVu?=
 =?utf-8?B?Q3MzenJjcFU5cjZnL3lZT0hxUHBib0thbE9SRisvUDJTM25xUVhtUjliNUJ5?=
 =?utf-8?B?aEpHUjdEeEk1ZUFjd0t3VnhYQVVucUQxSGdKTHNsRFU1bVlnb1E1b3NBcVZS?=
 =?utf-8?B?YkxSbm9vTnNQVDNqNDQ2VWMvdFZ3OGFIMzJwTnFPNjVUQzhIQkNLdm1naDBl?=
 =?utf-8?B?Z0R5eVpXZUpQQk05UmJVY0haTTV6aFcvV1hMbis1OS93cXpuQ1k0WHdUVlcv?=
 =?utf-8?B?SDBXSFNIQWRDeHVqbHUraG1XcmN4V0xQdXkyRkFIZDQwR2NpdEFtRW9GVnJZ?=
 =?utf-8?B?M3RiU0U3azNMYVBFNndLOUUrQUh5cWF4a3U3WVhxYjlJcmlBeWF6Wks5R21F?=
 =?utf-8?B?STNhbjdCMjR6L2hTSkMzTDl0c2hPNEQvRWRnbzh2aGJVSkZ3VGp6OWVUK2dN?=
 =?utf-8?B?Tk5CZFJWNFRqZ1V5ZDl5ekxZREoxby9ubDd6T0xWMlJrVjNWam5zU2VtS1Fk?=
 =?utf-8?B?RVRLa2Y1ZTlYekd3K3VKaGRxSnA0VExUdllNVzBCUmdoS1g3U0dHSURCaVNZ?=
 =?utf-8?B?WTV4SFVuc1JWNTVKY1J4MHFmVGpUYWZUaGZkaEh2YURsR2ZnL1FScm9RcGlQ?=
 =?utf-8?B?TXBrVUI1a2RlMmJFMWNoTjdmeWU0VUZNTFNDSDE3NG53akVHOGpKWUZpZmxj?=
 =?utf-8?B?VkhNRWR5TXlSNDZlVncwNnpPMFZpM1FXMVRUdDlRNlpMZk1pcDk2N0xlVTdL?=
 =?utf-8?B?L2tPMkU4Ylc3c1p5VGZjL0JibG5EZWhBRHRCWktYbjJVRmJrbXkzNVBubytM?=
 =?utf-8?B?VEsrYitvVUJqYllka1ZCS3BSZUFyT3ZLdmNzRVdKd2dtOHVZSW5LRGl4a1lJ?=
 =?utf-8?B?TksyemhsRW4yRXhKL2RJZXJFeHVKUEZxZSsxb29qTXFwdnM4WGRCakc3YW5t?=
 =?utf-8?B?VHFYODdscDhXZkt5S1hRcjNXb2hLYXk3SG5SMjRMQ3haVVJtMjJqRWcyZzlh?=
 =?utf-8?B?cDJDMmF4S3hhOWFxbkFOQll5em1Hb3ZNZnFNMTRqS1RVc1FuOEh2L0tWRkdX?=
 =?utf-8?B?SmJkUzZlaUhKaWkyNlJEWkFKa3pHMHRDdG9PbCtPVEUvUmNkZGExMXJWZnhR?=
 =?utf-8?B?NitoVDQ0OEJpZWxsdzlRRGowRUpYbUk5WjZvd1d6YThLSUhLUXdIZitlU2VU?=
 =?utf-8?B?bDZ4SWQyRllqcDkzdWsvY3NhSGFjQ21VZGtyZjZvOFlWYWVsWnJoNVgrbk95?=
 =?utf-8?B?VnQzVHdZWFluOHJ3UEZZZ01LdldQSGllSG5uQS9PbVdpYWtyNEFyQXpxWk5k?=
 =?utf-8?B?THkyL0NCNWppQTN6blJWTm45WDJBUXphU3ZKM3VmZHBjR0FrNU9SWW5IMjhF?=
 =?utf-8?B?SlczdEFtbTNlOFJQclFkd0Rrd3Q0OHdiZ0hEL0pidWROUVZ6RWFZcFIrOFZi?=
 =?utf-8?B?dXZNaFZZb2FoTTBzSkxBbEVZZW5MZUlpYi8rdnNNWmI0WDFXVjFSN1QwSStP?=
 =?utf-8?B?L2drMXVSM2pFOE1DaDFFTTVLa2RQcUxSN0tTZS90SFRZOWswTzFhUGR5ZXVU?=
 =?utf-8?B?azRzTUdmTVlPM1dSaSszZkt5SFBldU1sWE1FR08raHRnWThPQ1pGUElXRFps?=
 =?utf-8?B?L1luelZhZTc2QXVjV1VxY25JZWFmVkNEYVRVcHgyL1Y2RzJsU1hYSUthZ2NK?=
 =?utf-8?B?R2xNUSszZ1YwMUFDaGkzNUhFL0dpekYxSC9pSkZhem4rK1lyZDJ0WlZOZFUy?=
 =?utf-8?B?YnFVa2Zjb09XeEtyN2JtVkZwTVBmZ1ZPYzJUZkU4WTR5WnBqQnNzU3hUNDUw?=
 =?utf-8?B?QzNrVi8xSk13OXhERWF0WitIazdkRzBkUmZHVnNqUVJCTHQ5M3VpWnF0MU9O?=
 =?utf-8?B?R2VYZ2FBWDMwZE5FcnJVNThBUER5WnNBdTc5UGFSdG1MaG80dFpvU2t4TStZ?=
 =?utf-8?B?YlBNdnlBRHdDRW9RNlZESGpNOTB1ZWxRT2RoWEhWVTJSTmJtT2hseGVFYWZY?=
 =?utf-8?B?UVdYdVlEelhlSFJpYWp5d2FsS3dMNnlFZy9KSGVBdGlXTDZMUlFPbmpzYzBY?=
 =?utf-8?B?QkswTmlGdzdiNjBVWG5xOEpPUEZZbVRRcjhMZ3NwMVFtWHl6anZUaTMvVHRL?=
 =?utf-8?Q?UnNVRy6Jrq+IElng=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cPBzN45XAX7MwxjPfaWslWXQtYgo5v+Lwig7bc6QdMrB/dLo7kQEnwICFN0wFvxG/PXHGNDFLUUq8SLg5owNuxIGZyUm3ngsp6w1oV590EH8OWhttdmXHzjvEzFgel1P+OMaS4nNlb4Cgapkx+wZEvT1zvA2nCtqv8NokBllN/CCKreBfKGAFVOcVaO22PyIEqZm4Z2xfiPBvOUdaER8zZfzdc5+ybTl0AFramv+D/4wtwCIk2a1amSTDNJoXEf4xU5Tre9CK1gogA9rtC96zh0VkzD3StrOKMO45T48U2BwSn9uS+dch+wpdED+x0yVSdI22CiHe2bgrKX1CYoQnJNGtLZcP6upoWf4aYVzCtBEJEz95fSKgebMCZQlEkfl1nJIS0+zIG8IfQ3YWWkAWEQadRmyY4VaeAnrsIIY4XxMLplhSsTjPF5KlJhiNsS1Wusx+EVUF03qAxI3CdZHU8M6xHi9NxyIXEyLZrMWmJfaLpIA33yABECqqhEKXaSgcfepCOAswHyErN3t5W9aTK/tSluhbZHMUEyTbBUlfaEtvrQhOGCrj9KKBcpCCM4LAUZcjL9ssqUtnCZ2wGgR6FbCKkLdgZLtJf3LF12NYVU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4aabe5b-494d-44bb-5a93-08de5a9d23ee
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 16:33:29.3373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ph+uXFwXy4a/aSWa5BKU632wYXKxU8h3wCgurR3p1kGSgfYD2xfD9Ap/6I7hrPIj+fDNAfZaHm8lVhqxKdW2jODvxcN/L2VcIthWfJCV3k8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR10MB997727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230124
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=6973a2ef cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=GDB1kmrApsUSxlhMO90A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 01FBSGKWQ43D2hmnaqwDrcoXXR20mAae
X-Proofpoint-ORIG-GUID: 01FBSGKWQ43D2hmnaqwDrcoXXR20mAae
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDEyNCBTYWx0ZWRfX9NO3LBLsesHs
 Pkv6+RNP/4l7yyHw7PqjRQWq52dxuARmWIR1dGc0b8eouiQxcTuGydc3/RqOjqK9hbQ7fVp2U2s
 Z3GAUDN+xZK9xKrb49MIIRKVwk07yJKl/1BSsV9oAWr4qmTozpCuwFZZfPj/vpwmnSP+SjR9quC
 JYDc3PYU90JkD872JW3XAOMDt7HK3rZL3t/Hgg/UGZ6lzhV3Z/0yXVS38oluRkX5Bp09I8mISjO
 8PzdkR6ranPG6A95mym0VHZ73BWVhsxFkEaPp1/WN6niWKT/YZaP/XjEm4qWiS/TcpciGmoG3oQ
 7jw1URbqPXpVUXex7W/UXXEUArlEn9SNq43Gr1zYhxKi6+ffyQNqEqsB0JHISnad1fMOBr7DbnH
 p2+MS/RxdnRekDrvTxLxqiXaK2zjlPeEWBbACqWiW+w43miQisxIQEYOBaLXsGL8XCIyR6oMtRm
 8rySe0SxRxNI3YXEEQQ==
X-Stat-Signature: ryh1xd1o7mq5kgj67m8w7rkuymcs943w
X-Rspamd-Queue-Id: 24991C000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769186042-64017
X-HE-Meta: U2FsdGVkX1+fpei5pxNA/8tv3nF1pFgz/17omN2TiFVrwrOkNny6PHlbV8WQ+obGSGDg8eNCHvrWbZ5UrbeJMV2psi1eaIj9Ie7xmZgxp0WZ6AyueHO+mx/lX77vFWcqE4ZYixeTWBCxAUqgR2E58G7+JRKBqTWfBfeubOJlFeb44/mpOnhQjaEkxaUOga5rgNcZ7eNGP9Y4UgggQLa4EO+ENBle1WlsZhoBYx2rO0cOElmnWBfGr8LPA27etmH+dHKExtZReZZlnJI9qVTUE2FAhROYVH8XHIZjn/XDXfdbUxxeflgRWqtFhAkJfdcHEEtwaEEF5ov4xZoSmFTGrEgNp6s+oyZyIBtp19hp2DfMT/m5tEqpWUPCdy2Ir/qVQCqLCy4m4CeoaWHOlhQu0rTc/Ek8TAzOLK1kXHgNBBWyyclbbuo39sub4n0HScbGP5SZtqdDqaG4+hBMSlBuu90Z4WE0W9Re9VgJOqyolE2IEc4ZUIGGMfW9kZvwckbY+2BErWFHJkJaVaUE/63xIZxg6gcYyGFIUT9Ri3u4iRvXAjSmKUU+K7ZyVgG4WUz/ni8Yuqbr02GSe5U98dfHDqlYAL2E+2F/iqwsjCo5dRBgOhVtgh78AXW1epbeXTrQYq5rPg4QgvBJtg68ToPcu4pV+yE6KBp0yeRRCwbTHQIoYD/V/u7YmSV9ygtKVNysXYPrLeGV4qhlKnDd7O2Gl+qglmrRJiWMmXp1FW7rfN+9GDJd1JvUdJpA8Vyk6a9EULFnpxEQYOrIy/af+WPRJvLUKT44Wl5AiEBCnxwxnvONpp35XNuwRevAzd/x65QnptPZG+kpnJ1jPaMyRUikdKqv8N02+fJLF8UTdIKAQqRYoWx4QAvGR0pfOBK9GJXnOOsaky1qTZgT6DvkrzJ7ekfDl/CVSZr17v4tvFhrYsfhqqCLvMw//kiUzmr2NTV888G7FWpwsYthl/kpXBJ
 od6xNv6P
 f4BOC3qhi2oG+ZVC5qIjYgz7P8kEUuIHAOBagsEcJhZfKcvtFzODXMgPF7OgJl7/QxHSnMdiNRDBg0q+NlFkJT/6s+noHjeq2rErzAYAiPd9glflSF8oZqWJpbe/5GZGZGRVgkkyYLokbSAyD3ihTcS75JVCWEnOpN54f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 12:15:20PM -0800, Suren Baghdasaryan wrote:
> On Thu, Jan 22, 2026 at 5:02 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > These functions are very confusing indeed. 'Entering' a lock could be
> > interpreted as acquiring it, but this is not what these functions are
> > interacting with.
> >
> > Equally they don't indicate at all what kind of lock we are 'entering' or
> > 'exiting'. Finally they are misleading as we invoke these functions when we
> > already hold a write lock to detach a VMA.
> >
> > These functions are explicitly simply 'entering' and 'exiting' a state in
> > which we hold the EXCLUSIVE lock in order that we can either mark the VMA
> > as being write-locked, or mark the VMA detached.
> >
> > Rename the functions accordingly, and also update
> > __vma_exit_exclusive_locked() to return detached state with a __must_check
> > directive, as it is simply clumsy to pass an output pointer here to
> > detached state and inconsistent vs. __vma_enter_exclusive_locked().
> >
> > Finally, remove the unnecessary 'inline' directives.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  include/linux/mmap_lock.h |  4 +--
> >  mm/mmap_lock.c            | 60 +++++++++++++++++++++++++--------------
> >  2 files changed, 41 insertions(+), 23 deletions(-)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index da63b1be6ec0..873bc5f3c97c 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -209,8 +209,8 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
> >         __vma_lockdep_release_read(vma);
> >         detached = __vma_refcount_put(vma, &refcnt);
> >         /*
> > -        * __vma_enter_locked() may be sleeping waiting for readers to drop
> > -        * their reference count, so wake it up if we were the last reader
> > +        * __vma_enter_exclusive_locked() may be sleeping waiting for readers to
> > +        * drop their reference count, so wake it up if we were the last reader
> >          * blocking it from being acquired.
> >          */
> >         if (!detached && are_readers_excluded(refcnt))
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index 7a0361cff6db..f73221174a8b 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -46,19 +46,43 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
> >  #ifdef CONFIG_MMU
> >  #ifdef CONFIG_PER_VMA_LOCK
> >
> > -static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
> > +/*
> > + * Now that all readers have been evicted, mark the VMA as being out of the
> > + * 'exclude readers' state.
> > + *
> > + * Returns true if the VMA is now detached, otherwise false.
> > + */
> > +static bool __must_check __vma_exit_exclusive_locked(struct vm_area_struct *vma)
> >  {
> > -       *detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
> > -                                         &vma->vm_refcnt);
> > +       bool detached;
> > +
> > +       detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
> > +                                        &vma->vm_refcnt);
> >         __vma_lockdep_release_exclusive(vma);
> > +       return detached;
> >  }
> >
> >  /*
> > - * __vma_enter_locked() returns 0 immediately if the vma is not
> > - * attached, otherwise it waits for any current readers to finish and
> > - * returns 1.  Returns -EINTR if a signal is received while waiting.
> > + * Mark the VMA as being in a state of excluding readers, check to see if any
> > + * VMA read locks are indeed held, and if so wait for them to be released.
> > + *
> > + * Note that this function pairs with vma_refcount_put() which will wake up this
> > + * thread when it detects that the last reader has released its lock.
> > + *
> > + * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases where we
> > + * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal signal
> > + * is permitted to kill it.
> > + *
> > + * The function will return 0 immediately if the VMA is detached, and 1 once the
> > + * VMA has evicted all readers, leaving the VMA exclusively locked.
>
> The wording here is a bit misleading. We do not evict the readers,
> just wait for them to complete and exit.

OK updated to:

 * The function will return 0 immediately if the VMA is detached, or wait for
 * readers and return 1 once they have all exited, leaving the VMA exclusively
 * locked.

>
> > + *
> > + * If the function returns 1, the caller is required to invoke
> > + * __vma_exit_exclusive_locked() once the exclusive state is no longer required.
> > + *
> > + * If state is set to something other than TASK_UNINTERRUPTIBLE, the function
> > + * may also return -EINTR to indicate a fatal signal was received while waiting.
> >   */
> > -static inline int __vma_enter_locked(struct vm_area_struct *vma,
> > +static int __vma_enter_exclusive_locked(struct vm_area_struct *vma,
> >                 bool detaching, int state)
> >  {
> >         int err;
> > @@ -85,13 +109,10 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
> >                    refcount_read(&vma->vm_refcnt) == tgt_refcnt,
> >                    state);
> >         if (err) {
> > -               bool detached;
> > -
> > -               __vma_exit_locked(vma, &detached);
> > -               if (detached) {
> > +               if (__vma_exit_exclusive_locked(vma)) {
> >                         /*
> >                          * The wait failed, but the last reader went away
> > -                        * as well.  Tell the caller the VMA is detached.
> > +                        * as well. Tell the caller the VMA is detached.
> >                          */
> >                         WARN_ON_ONCE(!detaching);
> >                         err = 0;
> > @@ -108,7 +129,7 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> >  {
> >         int locked;
> >
> > -       locked = __vma_enter_locked(vma, false, state);
> > +       locked = __vma_enter_exclusive_locked(vma, false, state);
> >         if (locked < 0)
> >                 return locked;
> >
> > @@ -120,12 +141,9 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> >          */
> >         WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
> >
> > -       if (locked) {
> > -               bool detached;
> > -
> > -               __vma_exit_locked(vma, &detached);
> > -               WARN_ON_ONCE(detached); /* vma should remain attached */
> > -       }
> > +       /* vma should remain attached. */
> > +       if (locked)
> > +               WARN_ON_ONCE(__vma_exit_exclusive_locked(vma));
>
> I'm wary of calling functions from WARN_ON_ONCE() statements. If
> someone decides to replace WARN_ON_ONCE() with VM_WARN_ON_ONCE(), the
> call will disappear when CONFIG_DEBUG_VM=n. Maybe I'm being paranoid
> but it's because I have been bitten by that before...

OK replaced with:

	if (locked) {
		bool detached = __vma_end_exclude_readers(vma);

		/* The VMA should remain attached. */
		WARN_ON_ONCE(detached);
	}

Note that this, and indeed the comment above actually, both get replaced in a
later commit :) but I will action this changes regardless to stay consistent.

