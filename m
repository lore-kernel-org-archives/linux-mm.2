Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C101ACF65C7
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D00E6B0088; Mon, 26 Jan 2026 04:45:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253A76B0089; Mon, 26 Jan 2026 04:45:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E0C76B008A; Mon, 26 Jan 2026 04:45:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBD186B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:45:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A29D21B072D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:45:49 +0000 (UTC)
X-FDA: 84373633218.15.DAF243D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 52F26160004
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:45:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZZEY6Gkr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RBGXJGeJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769420746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGdpZYkCvE3iOFEeFIeAG6AFsMGpVlqUna6iftYCnS0=;
	b=fPnu+BtVZ39F82OaEKOs4UTURmZYbmthh+Smmb8Axn7WIp1LUXj5qngf3/8yTcuyljkFWh
	pSrfG7EzO6fQrPZol/74cftAJYSE2wSMeDYJxTqQb1zWmbujqGXOlCrE9UxzcrumODjn+s
	S/4sGFuw7QBwP+2MKbh6e0rfsK38aAQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769420746; a=rsa-sha256;
	cv=pass;
	b=Ux2hN70Ndl0Pg7wPcTBl53fE5Muajikbnb96tqZ4WbbbDO9eVbcF/76/Vr/Lo8XVgGOXwt
	vMxI9rMrCWw81T5Em3oN8LFKFbjTTBB4qQ79ujrxrzbzMcQLBTbj/iafDB8osbz+Qu5Oqa
	bxX7AfZphsAW2dR+GxIM1+A18Y9ocRE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZZEY6Gkr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RBGXJGeJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q4XG7S996516;
	Mon, 26 Jan 2026 09:45:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KGdpZYkCvE3iOFEeFIeAG6AFsMGpVlqUna6iftYCnS0=; b=
	ZZEY6GkrFBcU6vv9uuvsl/TjLvfdzgRSHXAJiXs487qILYcUX+QW/KKMcPqWf9zt
	wNtaA5TM+sG7F9vH80I/nnhaeGGqqWf8A8G3yfu9Wfcl59OkEMkfaOu2l7kiSKH6
	rNzYObipdB3iqwnl+Rrv8ZqJVCodN0telilqP86KVhT5/9l7nsQIYDjGpT5TnztL
	/KHYAsTcMw75Pqi2MhmyfDqVWA/O6eSU28lY0W8GOWnPbV7cfKVKeQCY0gyJB7oU
	NpHTeYBzZSS2yQsDCwi80zP3INT22A9+MYN9/9QyIbCv1dT0FZHqplQZ2vfdS5I0
	S9RDOcHWK7LhhO+CTX9Ekg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvnps9juy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 09:45:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60Q9EoES036083;
	Mon, 26 Jan 2026 09:45:35 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhm16nr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 09:45:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iwtakbtv7Ccw/XZV3zn88XEpwmqYDfgWMq4YaruWsuruIUTPvyGOqYVBzvz6V8epdfVZo3ouxMXinMbmcxzjbT8kGeQ9w5+z1M2p3znOaqSJO+9z2wcpyxpbdRzeq/Ul4ijLDd+fXp3FSUDH9I3Fba1g0iQQBP+7WQMMhOCLXKtMRpQ5/MHutQOT27nzw+wvFtdPZXBDZ/TlptDRDtvcpNBV4R2b8GciJV4Jero3gdGZec9C5LfMVLiJ8NKgX+5wpZ4F82fGZYKxuVx50+n4n9mGwUp3vXbfvMIW62lcUc655Asasuy4g8EMo4TGFsSo3CIKewlVWU/hFdcACkZh5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KGdpZYkCvE3iOFEeFIeAG6AFsMGpVlqUna6iftYCnS0=;
 b=VCNxQPwdj2Q305ZZypWMoxP30c5jGf9yVJ+/wk9oQcImHQXvZxDKJPQZK4NBG+TATFBtG9tXlhbsd9n/wQeN4cJV6UJ2q9dpIGBMZA4lwrba4jooe4D75Sf7ysJYIrKwVdkb3c63c1bFoLzKhKPZhOKjCLxnR4U0TNbb+HpUTenLMMCmutY1lzfWuffbRW4nz3O90KNslbLj3d1MiWkgvbRfpsBbpffeRVJdE5XOJK372xAXBkq54EBPwOHIyE1VA+V6TiiH62e6PGIppgBV+57vF4aZjeB0dZ0nZqWFFTNhrpApIH9s6LEk5DPxcg/iN/OOXhoef3pweZC1kW78oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGdpZYkCvE3iOFEeFIeAG6AFsMGpVlqUna6iftYCnS0=;
 b=RBGXJGeJkbtE3h32s7KHcRq88Tp2KMgniAmZAL11zJt/r5tLnlXd5Ya4/DfsLYL49TnJBcUqb71ghhgpSVkXAYhOGoJb8dLP8DPbRawmDeUD/uxb2/luqrIYVO9doVocR/r7KU08OeYt3SpLzkW/g15/eOPL/2Bf+I6mPuE3MJ8=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH8PR10MB6599.namprd10.prod.outlook.com (2603:10b6:510:224::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 09:45:32 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 26 Jan 2026
 09:45:33 +0000
Date: Mon, 26 Jan 2026 09:45:30 +0000
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
Subject: Re: [PATCH v4 03/10] mm/vma: rename is_vma_write_only(), separate
 out shared refcount put
Message-ID: <97d33d7a-66f6-45be-995d-04247d514c39@lucifer.local>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <32053580bff460eb1092ef780b526cefeb748bad.1769198904.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpH1u6N7FXi=2Gn+WWDW5M5reupQVkKebGqRcbr84oj3HA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpH1u6N7FXi=2Gn+WWDW5M5reupQVkKebGqRcbr84oj3HA@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0326.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::19) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH8PR10MB6599:EE_
X-MS-Office365-Filtering-Correlation-Id: cbcf7363-5180-4e55-5ada-08de5cbfa668
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjBxak14QklJS3VtdmdicGVlRUJROWsyc0hoNERiMUx5Tkl5YmUrTkd3a1I4?=
 =?utf-8?B?UnhYMlBEaWNoaUlUMEV0YTNDcmtMaFJ6ejRabEhhTEJ6MlJGbjF1V3paa3NQ?=
 =?utf-8?B?Tzl4OTN0eEsrNlVyRmZjam5VbVA5dXc3K0orMFR5RjNwRGJUSlBFeGZSd2E5?=
 =?utf-8?B?bGh1L2lFTHZncDM4SVowZTVYMUVibGxZZzdOODA3Q3p4bVZadWtzbko0bVl0?=
 =?utf-8?B?bG1lTTNjaFJqZWdFbXhrQmloOVRvUkFmeDRNSC9Pc1hYdkw5SWREblNaTHhZ?=
 =?utf-8?B?TlByMWNhckJrSzRhVHZpVEt0K3ZtU0NJdndhV200dTdHd1hxeHQ2WXRjb0dh?=
 =?utf-8?B?NXdzdVFhZUJKaW0yeG9lTC91M2ZydjE5NUVpeTVQakVTbG9McXhDUkJ1TEY4?=
 =?utf-8?B?NWhjaFJsSTAvR0JFTUhSU3VsUFBaSDNiR0cvK1hpR2Vwdk9Nd2ttclBMdWg0?=
 =?utf-8?B?YnROVFFzNWt5amgrcUNIK01mZmR6WjhmaEtXWmJGNjFDbnc0R2tmOHpZbGJw?=
 =?utf-8?B?OXJqblA5V1B2LzM3MG5vejZaS1lMLzVBMjRmek0zd1JuNTVkZWJGeHlSRHlS?=
 =?utf-8?B?d2E3N0Fld1ZHQzcrVFhDd0ZOMVpOeWRlUzRzWUZ4WGQrK1dZZm9nOGowWGNp?=
 =?utf-8?B?dENFRWlBMjZybkVobWROQ1dDRldKaVRabHozVW4vTnQyUkpUZ3ZJeXdWc1pR?=
 =?utf-8?B?NXpxb0toeUc2YXhob2dqWk80cFA0SFFmWWlPWW5nOHYrM1JGdHdrdVpTajJ1?=
 =?utf-8?B?aGdPZGJ0MGd6a01QM0hxVko5dS9VeUxsZ0FSdUozdHE2UEw2OVVOUHBFaDVY?=
 =?utf-8?B?Z0RUV0htSko5ajdqdmF0L1lwdDlUMURQbE96dE5tcHBpSjM0cUJLUHR3cllH?=
 =?utf-8?B?WWJXRnpmTlhlM1gzcVlDTXVFL0tPRm92YXJzRDlVelBQWTlFRkRHcU9KMURh?=
 =?utf-8?B?aSs4TUpSd3RaWlA2TFpxQ1ZQWkV1Y1dVL2pOT3lYcVVPNkd0MzcvMnU1N2tn?=
 =?utf-8?B?TjBwK3FMVWtLVk5RY2tCY3FHWGNFNC9HUFZmSjFFTHVCWlppY2xUZTg5bGtD?=
 =?utf-8?B?SVY1S3JHKzlwQ2MrTlNCcGxIVTF1WkdMVml3WWxHV2Jya2xJYW1lWlE5Y2Jx?=
 =?utf-8?B?RlhtVWsyakJ3aVRIT01ETnpBblBHMDNMTmZUdWNSQUR5MExjT3ZaRWlsMEdy?=
 =?utf-8?B?YS9FaTlnT2tqd3lOU3BrVVhEc015T0xsd2FabG4xelc3QTVZVm83R2JKUTZy?=
 =?utf-8?B?OUk1VlM3OHBZZEx4cDdHSG9ZcGRqNHpFRWEwWlFodFI3Z3Nmd2tZZzdMYU9T?=
 =?utf-8?B?NHZIVTh2ZEhZWDMvUWpFRDBPVlMrdXJNZWNuZ0E0Q2tZTllBRi9NZDZrbWZP?=
 =?utf-8?B?YXdxY2d4blc1ZEhEci9ZUzN0NkJtN2QvdEJZa0ZEZENaaXA5RWRjcWZtSGd6?=
 =?utf-8?B?NHgwKzZRMzh1WExyZ0pBd3dxbStpUnNZdHZaUXB0SEhPMFBnWnVOWWluMFBa?=
 =?utf-8?B?T2p6TjV1cEUzS0N0WDl6RW50MDJHWG13d1EzS2tHcXFTRHpvcnNvRVdweG5Y?=
 =?utf-8?B?WmNjbDk4QkltVzk5WEhvUE9lYUFoUHIyS0kzcytlM2NKc3FQYlE4T3Fwbyt6?=
 =?utf-8?B?TDEwZ01QL3dLbEE5NlVpemU1emV4QXp4UUdCUjZjeUlJSlRZZ1R0S00rRktJ?=
 =?utf-8?B?S3VlYkZDRDV0YWZ1ZWFXSlhNSG5hN2tSc05mTjcvNzFtVTBuWitSYXdPY2sv?=
 =?utf-8?B?Z3lNMUVvYnJZSjRxVFdFM3owZkl1QmVZOG5ONlZVWUkrL1ZjUWlNYjZSQ01Z?=
 =?utf-8?B?Z3V2dDZUMVRFMkpYMXMvcmptWnhBV3hWbGM0TVZSMlYwOUxWb2dmR1JOVER5?=
 =?utf-8?B?eGtiZFlMQ2FTclN5dmxvL3RDRFAwVzlrMDhWdTRzWCs5dE1SSGpTbnQ0TzZx?=
 =?utf-8?B?V3dBWWNRZmJIVGVwaFdMcE5PTUlmZEZvbnUybnB1VVpDeTVKNTY0ekRnNEww?=
 =?utf-8?B?TEpOVVFVeFZOb0lsMHVmUHhJZ1g2TGl6YXR6NU95SW92b2kyL1hzK29qTVp2?=
 =?utf-8?B?bkZNejZWY3Fqb2ZJS1REbnpSVzI5SUFlU1JZQlJRdTA5ZTJUMzZzQlQrcE91?=
 =?utf-8?Q?uCGk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGwxN1NNS0UvWDN6cm5sMk1ISzdWczdGaVdDL3R2UGlpUU5DUG5GUisyRTJG?=
 =?utf-8?B?QkZwek5oc2lTY0dBZHlnNUhjR0s4SWFESjBaMnlZTE1hV3hOSWpzWUQ5UkZY?=
 =?utf-8?B?L3p2aHBDQittcDdKeW9mSGkwamxrc3FsdzN5ekJZYXlrWXJMMW91YW5FSFpm?=
 =?utf-8?B?YVNPd1dvM0g0Q2twcUdJTjBOOFJJTk5yT2R6OWx4K3RqT3NEWHZzUXBKL2U3?=
 =?utf-8?B?bURDOVlpTitqd2MzV1Qxbis5c1BDWit2VEdPanI3L1NRNDM3aFNHYTlTdWVr?=
 =?utf-8?B?NG5aMEZSZjJmZDVPTkdNa1NIRHpIc3hFb1ZSVnZ2RDlvOHdPTm9zUldmZ0Yx?=
 =?utf-8?B?Zko2M01WZHhxbUozUEJ4bnd0UXU5cTJLdk5VdVF0ZWxKalpHVmNvN1RXRTls?=
 =?utf-8?B?dXZ6aWdycVJVOWF2bkRuMzdQVitVRWNOb0xTTDVQWTR5U0NSNUoweldNTEpO?=
 =?utf-8?B?cUNJOGJZV1laS3JmaGxwZEdvSENhRXBFbnB5YmhkVS90V0hwT0xEV0ZnKzhn?=
 =?utf-8?B?K0dZbUh0TkJEa2RlVFJ1RExTNk9BSitxeFNXakM2MGxhci9SK0JPTVdSYU1v?=
 =?utf-8?B?bWRmS3hDS2ZXTERjeTJROEJEcU1WYXVhYXk1YjFvdmNHVzVsbjJrWHBnRkZj?=
 =?utf-8?B?aWJOL1hrdE9MQnJCNzBIb2dMUjRuVk9ndUMxK1BIdERDSHM4SVB4L0JLOFlh?=
 =?utf-8?B?ZG9TK2g1VHBoMGlqRlF5MlEzYVlEU0lmYjZ1Z3dGYUlub2JpS3VMOGRac1lX?=
 =?utf-8?B?VW5nMStneGR4UXBKWjJWVEhDdGM1ZHE5Zms3OHJHQkNJMStNa205NysrS0Rh?=
 =?utf-8?B?WHp1ZnJkTVJYK1VxVnA4N1p6M2RNSEdFb21zaEJMdHlCU1lxak5FMVhnZ3JO?=
 =?utf-8?B?eGV4R3F2dU9CSlVDalVJUVY1SWVyV2gzbCtlM094RHhEYUo4YUlKT2RXak5Z?=
 =?utf-8?B?RFJHSzY5UzJnTG5BeWx6dDJiTnN4RmpIMTNZNjN5UkJUbi9zc0lZV1RkZTc2?=
 =?utf-8?B?QXArUjFnUTNlZ3F3K3dnL05jV0NPQWVtQlUxbHQrOE1jTlNmWTV4YytNUjFz?=
 =?utf-8?B?Wmh4VGFPUGtPS0lJbVVrSWxpTU9HaU1Qdll3WnljbEdSVWs0NUpudmpmS2Ri?=
 =?utf-8?B?OW5SZWN5MkUwamtHMGlpUGs4cjZkYUlpQjltUk5WTC9taXZ5WnlxRmVPWnM5?=
 =?utf-8?B?K25uS2lCODUwVDZycXBPaDVFV1dpOFRGRENxQlZ5dTZGclpDQVphRmhMU3FF?=
 =?utf-8?B?Ums0cGJUa1hTdS9zRVBuZjhVOU1TcE40VU9nT1ptT1p3OHNoRlVJWTFvS3Bi?=
 =?utf-8?B?UmYxT2JVYUhvODdrMDVQK3oybXFLeDJDSjBEU0g4Ym1lSWN1Y3ZraGxTOEkv?=
 =?utf-8?B?U1JkaXNLbE5MbFhYVVhkQy9uUWFSMzNCNFEyajRxdzNQc1J2andkZkxuV2Nx?=
 =?utf-8?B?L2dZNXFkUlpOVkVVYUZYUUQ3bXFpc3MxRXhNNVdiTmxycmtNbzhRMEJQQkJI?=
 =?utf-8?B?cy8rejJoc3RBUktqREpMazBjYnlrNkdpWHVMUkd0RUxEdEZkVWxmTnFHbUVj?=
 =?utf-8?B?d1AvSXJLbldlVmYzdnorcnc5K1NFTDZEMnQ1THRMVTFhOTJyODR3dEJienpJ?=
 =?utf-8?B?aloyUk9PM2ptdFNXMXdRc3o5UytZZERDWVB3QWZVV0dvMEZjeXNDaENuRncv?=
 =?utf-8?B?ODk4aFo2cm9NSGdSZnFOVHBucjdnM0hzZmcyTHlSL2dwRVVTVmtmdVp2QXFZ?=
 =?utf-8?B?OFBDbjc3RE0wOW1ERHNJaHVteWN5eXBuRWcwdTFFZVdEOFNGdlA3S2dWdFpL?=
 =?utf-8?B?SDZraVVTNnNVOW1ISWVNQTh2ZStlNVZocUpTWGpNTmZVY2ljRUppeHl0TzBE?=
 =?utf-8?B?MG5Udk83VGE0YUtVMHdQOHpyWUxkUlZIVmVXVTh6UHhScW1QeG1adTQ5ZzNY?=
 =?utf-8?B?TUtWeVlqQ1lVbXNJSnN0UThaenhZbS9hSGZmbUhyNmZsWitPQmJzRnhhSVhN?=
 =?utf-8?B?YTRZM0hpS2RQYmRzU0JrbUdFQ2hBcjNMTjEvb0t2VE04a1NNVyt1OHloOHdz?=
 =?utf-8?B?MUw1MzNCUmJpSTUyemdxMGd3UStSQm16TjJ0WkxpWktQWVByc21FRi9SNnQ5?=
 =?utf-8?B?Q0xxaXdQczJJSFVuMGloRnR4M0k5ZnJSeUpuNkJrODZQc1VJcFloMk5ScnYv?=
 =?utf-8?B?aVdiYWRTbmVDZTVSWlFPVmEyancybENyUEJFQnUrN2dYWVFza0lCSSswMEUy?=
 =?utf-8?B?VXNlT3VYbnYrdk01WWI4YTBxaks3OUNWdkdBWmVnUkF5MFdpTXNpcEdmN3lR?=
 =?utf-8?B?dHgrVHNxZHc4N2F5cjJ1eWw2c2ZiVTB0ZzFwdjJjMnZFTkI5V2trUUppS09F?=
 =?utf-8?Q?IA2LKl16kKjJ4X04=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	m+8sZIXo96Rls2Tk4E8SBhh0HezhF5YlWiWSJGB7v93+/COu4vm72OGGHbBrNDVaXJ3WYQnI2ExhiLRNF0K7nMDgbm84rPBCd/Cvl8t3o+k1fNkGFiRqi6Om49DA2N22mw9jc5ZACI8hAkeAqG7ziVHftlGxSj83MXUL/9a4pGHAiNHz2QQ4D82L0b8SRrOThcHoCwY3N21PdLfE42MkbqxD/t+nvcWgwi3c9E0QMKYUDKeH/fBOrqcKjSOlzg6ml2so5nWrCbEZ7L4tBl8kZAeXU+cEko/nbg7CmpRZPpb09uJBTEFw3+PltlX+W00O5a7C62Qma/8SpPiTwwB3DaEMT2jyPQlf5f2A2DueYnXplv+cbyVnjuQQ5ZwxMfu7VXtov8ckQqs+WODSGlOds3hvBGztRlEsuXqGsbz7UnnCE6XXUdvwzvw3aQ003zUVgX946JvdM84l4wkMYr0F9yYmSXW8ugRIrwLKhC8Z47rqxVN+TBqgoBiqmrsYK0bXBe/ntEEIOS8q2YKg0ydFKZXTsn2be6jZ8PIEs0XLlO8J+zmwD8A/9gqDRCNawDHup3dLp/0DF9bh5sqHrljiYQe3ZpjXMZe9Q7ulyzCx7Pg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbcf7363-5180-4e55-5ada-08de5cbfa668
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 09:45:33.4649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vagXZXzd+ZBX5xpgvrvTATm8UvPITMznYBbZOFDVN5JbmcQe+Jo9X5PFNrdQ2PUmE3JMZCFOHbB3rJlYULCxHwZV+31k9VAvbfnjOg/TP8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6599
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601260083
X-Authority-Analysis: v=2.4 cv=dY2NHHXe c=1 sm=1 tr=0 ts=697737c0 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=z2NceagshScTgvbjF9QA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12104
X-Proofpoint-GUID: UKkkC5UCtuw_7i03h1qPNMXkKKBZJLPk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDA4MyBTYWx0ZWRfX1XM88Bn2iPjB
 ByUA0ht/GR2ROY+9+Di3miaSJLGJBBCYUGFkyM2jIZUPIRNtsGoDfQvMQYFRpIGDcH84HezH+BA
 4tQ4xYxcKZd3JlapPkgAOAK72EzPeffhnzW8fWXt/5wyxZNeQ9NJHQ6Oyfom3t5arYqivuT7DMU
 0kwk2rJzv3BKdsWXds836xTXfFMMtPR2Ed/oVT6I+LJRBRy7ljWf9eSKBhz0NJz+v7UJXdPtO5Y
 S2TY+mt4BJqrUMSOOmkDlRzJZizTeWc9p3oPsIjl9VqPuwSk+F2VNS1qWqVx6XKFN9yXPzFrTbl
 pXMFuaqwEqqBEDg6hvMj/gnrpcLTVQ0yVYqSvnj8ji3gQWJllPJ07npL/YfsXmgPocZhIPJdtAj
 L2vV8D+2SIxK5RFXFaWkyW/9t38MgKW43nt2J32ZSGwU03WAH+W/NgbqxeI3AXdcf23JbO1UqK7
 GO5A61XC6cpLLdSz5sZ6cQLyY3P5IpPKbPl+T2B8=
X-Proofpoint-ORIG-GUID: UKkkC5UCtuw_7i03h1qPNMXkKKBZJLPk
X-Rspamd-Queue-Id: 52F26160004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: n7esjpmdhusdrzejww9uy8cje8wjfwdw
X-HE-Tag: 1769420746-862006
X-HE-Meta: U2FsdGVkX1+YYCPxIDDtgOhvHrENlnFnkXuVQux35AblTXIcNVU6ds7t65AIIgxymBmmhaKvec9KNPe2QJhJbSvO2KCqeI5WjkG4nm5/zAGHRFQau3ZnLaRJvlUhpNnShVuQdXRlYt5XkbHQCOueuu7x4oxTGIYaFggGrLlD5hvV/nkkviDIIXd9Dn0Mk3wSo39+FR7fCFBGLVl95qv5mmOXTkKp3QP6OFJcbYWEkaPTh0PAEwAz9gNitGbKEE6sa00O6DIu0w86RTophHd8SHFCQUYtB9+TCa3l56wFQef08T5V74qYprXIxksZI9etDM7vLLivKXp/I+Zjrl0znzqJTgCDgOvILnlMNQzg8vd/3KRok84m3N/484CiQykyPJlAxwzxmTFsER+5WC3mzKhykm2krW4qa6oViOgCludQ57+hCVyqweH7lUjy1IA+YXPRa0l7lncWg4sRpdeoqKwACbTjeUsUkHNc82NG9eCY8ajeCiZoM4g8IaQqJx03NmEgSQ9cnSwOZnjqxaPt4h1sqJZuaaY2zRv4QIdqUuAKv+iap1YSQTJVkfwEj35PAQ4meb0mz9mYjnXmXwVQRxA6l/tquFMqzHy5yYMi7lDaQKkTklLvBTuJjuVk5hFYSY/gtdcoeRwu/u5BojQUbik2fI7weAP7j2MueuAT450M30E0pkwYBQFw00KCVayNHMU5HLHy0i5M4sBbo+/lS3E1dILPYVKZ0KSKIT9e052Ujhz/6GZnANaeX0+E5yaIezYhNCtAw4grmqXaWkQdw1qa0qaPcfNJAVlwvhAHjiXMhdBlYcsGHwAGzr7DdK/sxQ/QmVus4NgID3urKA4Aexku8Sx2zxoQMPT1AmrohI9L+MVnoKYypnCfyBpDe52grWnfYJgOV0auOVEmeEu3TPUyloGLzF2tUe42PFGAxqHUavH/0s4t7wm/3yDyDO0/JTWej8lpIYMHJjLQpE+
 stu67BSk
 qCqpsGum7yXLi4x8ZhjbrGxyQFEnG4rhdAxkd0F34DanjkmdTgdk1my2ZR+FyX+HHfvC6lTGTZwDJiRLtBxQvZYpU2FphYM4uz8WKvxCCd+eLnh9MdgfhoX5zdKJns7TmVg8asdwqk7RIA3nxBJ+deYBbM2DPC+98TS6l5/W6RhISNZcJymRMea4e2bX2N6Tz45dYzvf0KGbAHed3ZTy352Cwfdcgc/diiTLNKAvd4ieNKUMRyqz12l5bPbMYjf2jsVGN9iEj8uksqN0YhWjqWxSJk4hdIZ7GL/fYH8JarXwXNcc16EkAczhBPKigSdO0ktpkwN8lkbDcooefML12Sf+g0YZJ+iG5Fx2Wd8ThbfqwwFSRIdgpdFXbLnlutXhOXYod730PmdQdeSwo5YNajPLheOoVotLa08mCtQCCMhL8o/6KceEN79nDLOisQoGAFwppCMVaaxeTaUKfiRkfUp23INDfWMJeI//2Uw3aSXv6fo0fn7/0Rt583tmLPN8rRAGOMNL/nxUakagD8o+q97LgsEgRvSjuC/Xv+lZsEMuwAvN9kLmKthYPkyIqIYpRLEQYGbFCKXuCtEiv34QJyVjM3vpEW1KUeLH1bRYC3Cf4Hro2LTnAf6JZlon+cK2jRydn4ilFNOdZAh2DcR03ozaR9/zL5Df9hSoKtBVOImWTFFrCbCMr/dS/9nkpMigpvaUw3/ue+zwF0qrbDgm0tVogC0ZMO+eB1r4ErfO6qSZ6J9FDq9bEMhxZGngw3CpCd/Mmci7JFViEx3YjHlzK+fXdDI7mLDpiMlOyJVrOwW3JYO7jsBYxszzmlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 25, 2026 at 09:36:19PM -0800, Suren Baghdasaryan wrote:
> On Fri, Jan 23, 2026 at 12:12 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > The is_vma_writer_only() function is misnamed - this isn't determining if
> > there is only a write lock, as it checks for the presence of the
> > VM_REFCNT_EXCLUDE_READERS_FLAG.
> >
> > Really, it is checking to see whether readers are excluded, with a
> > possibility of a false positive in the case of a detachment (there we
> > expect the vma->vm_refcnt to eventually be set to
> > VM_REFCNT_EXCLUDE_READERS_FLAG, whereas for an attached VMA we expect it to
> > eventually be set to VM_REFCNT_EXCLUDE_READERS_FLAG + 1).
> >
> > Rename the function accordingly.
> >
> > Relatedly, we use a __refcount_dec_and_test() primitive directly in
> > vma_refcount_put(), using the old value to determine what the reference
> > count ought to be after the operation is complete (ignoring racing
> > reference count adjustments).
> >
> > Wrap this into a __vma_refcount_put_return() function, which we can then
> > utilise in vma_mark_detached() and thus keep the refcount primitive usage
> > abstracted.
> >
> > This function, as the name implies, returns the value after the reference
> > count has been updated.
> >
> > This reduces duplication in the two invocations of this function.
> >
> > Also adjust comments, removing duplicative comments covered elsewhere and
> > adding more to aid understanding.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

