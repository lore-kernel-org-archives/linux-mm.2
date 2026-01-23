Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 319BED778AC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 18:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB406B0537; Fri, 23 Jan 2026 13:45:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A25A6B0538; Fri, 23 Jan 2026 13:45:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2594C6B0539; Fri, 23 Jan 2026 13:45:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0EFF66B0537
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:45:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF3E1B9E60
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:45:12 +0000 (UTC)
X-FDA: 84364106064.13.F289F3C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5353440006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:45:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CRybV8uL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jymJ+UeF;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769193909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=as+kX1rMpDUwon2iMLa0bSG+EPVBv8FaAMm4SDmujuU=;
	b=A0BHKQvfO+wBtGCfI/a++wt6YF+/oAqNr5+ifgmR54gGu3Vc0KjiuTylRGPKjFQZhSN2lP
	aKD25mlIzqyMWB3UgTu96xbY1aidAN9YomT7HewRuTMUVnkwLXeRleZjgw/CPaNXfrUoNR
	xXW0dN8THuyVUAbOaqOxYbm6ozbwgK0=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CRybV8uL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jymJ+UeF;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769193909; a=rsa-sha256;
	cv=pass;
	b=5N2I4FfMPs+vQUMqdIKo81vF+bExLKke745c4HFmqzaS9q/udE4x4rQd7rx/3jcJ9NXyq4
	CpI2YZvzy3NobSSRzJvxmQJemFYaJZtO/SHwzed4U6bf06KkiAIay/C702X3D7fc3b0lfi
	3ELxyAodq34rxhAZPTPFc3zS3jwcp6M=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NEhrZW1884091;
	Fri, 23 Jan 2026 18:44:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=as+kX1rMpDUwon2iMLa0bSG+EPVBv8FaAMm4SDmujuU=; b=
	CRybV8uLFD8m/9FwfHlO8wW7o9BdrUM1mYEDT149WfF17uwMQvSZkFKsgD9Xu/Sm
	RiFgLseGxCX+rR5iIROTp3+Ib/y8CSxzSOq50So67T10tg9rSv0KMQdbb9bjwc4E
	nL6lbmTAjSoC8DNnhVD6OcR1bclXuDPhiBAZ12eOEuqZsGQKK33A1FlQf+hnBNIN
	3t3SGC1z+MVlleC5GvJGx4mJeVb0QDIHH1l2yzwsVGi8bI0J0T/bLTNdxWgjcQBc
	E0p7iotwyC8H8svZsYk8t+K435csXvHLM/ZMleI8x1VlASJy0YtqssRsZ9rctkle
	FY38U2LQnnSg23zG/C0tdg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8jwyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 18:44:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NHCgXX035795;
	Fri, 23 Jan 2026 18:44:53 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012053.outbound.protection.outlook.com [52.101.48.53])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bux4yk4wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 18:44:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j6NzYamw0TvtEmEnuhpRBFadXEOdXE4/aaKZBASUh17ViXp+VxYm1JFl0rZxDyHqwM9hrjQqfgx4/XprZtnGbx5j+tBepEvi3dTiudfFGa814N+qmKE2WWemsaVHB8EyloaxFIMFx6HfL+Yzu5W0dbkXkXyeJ/7B92/MHbDP7jKf/tOSyXtshxXZo1cIGMiZJ0rsNAoKKqCAss3vTbc7APr/2trjPvxkWSBCKNPR8NSZI1po3+89CisCjuTFn4vAQRFJW+/sdG6psWRqlH4WzE+LXri1TZTSnuI6/Js1yhoj6V0nYujLnYsyK3RXj5XaJxHEIk/Z8xp9UHos6Vbj1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=as+kX1rMpDUwon2iMLa0bSG+EPVBv8FaAMm4SDmujuU=;
 b=kmF8/liQJ+Qxvf+r+IqhJgupIYezeln3Xorvlu6AwYQSz1lsciCUvnkK/HzME6KBsTrKhqaqy/sgUE0q4MXkpjqbBhbw74se3Fr2FeeDeeznzpSpekl8xcBiyXY9blPkU11LCSFaEjuPXD4q/yUrZk6N52X914oTrLYkLoJb5l+AhrDSARYHam03kXVnP22U1RIo+W6Rb0+sFWd0Bld4kcC7fh5aOJeasjrQAgjbVxtxQytgj1s8YWEz5PVJMSsHJqDrm/1Tnn5JHaRbg4h+kIDrfkF5zVLgbIA/hcuibUyxDJJtW321TTssfT98MyLVfPxsuPTzd311puikOJ6SAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=as+kX1rMpDUwon2iMLa0bSG+EPVBv8FaAMm4SDmujuU=;
 b=jymJ+UeFaGQsew3aeGNzCI+qqUkCLpqbEBazjBqLFDrsoLunM5XafCuoZkTnJzO7TRiO7ZtAC7Kb46LvaU3+r8PaLPDERjWFgz1d5waRxFerctcL0A+aYkjZ6FUECYwu7W8+/cF4T2OPrzINL0LM1Dlp0XVf2kZqIQbBMDFjBRE=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH7PR10MB6130.namprd10.prod.outlook.com (2603:10b6:510:1f6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 18:44:47 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 18:44:47 +0000
Date: Fri, 23 Jan 2026 18:44:51 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
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
Subject: Re: [PATCH RESEND v3 08/10] mm/vma: improve and document
 __is_vma_write_locked()
Message-ID: <0019bd45-be27-43b5-bf80-1f8836c2ea91@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <70dcf80f79ecd00a750ea17101061b0949119429.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpF1LthyP2FR4T8iDd+zOi1WAjqma2KBkHcCJsOjm+s32A@mail.gmail.com>
 <b267b699-f312-4387-8dc0-a14efe72561a@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b267b699-f312-4387-8dc0-a14efe72561a@suse.cz>
X-ClientProxiedBy: LO4P123CA0410.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::19) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH7PR10MB6130:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d4b4883-c261-4c6c-701a-08de5aaf7bd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aFZ1TVN2RXlSL3ZRZStzaEZteWNxc250T3lyMGlBeHdrL2JTU2ovQTJBUmIx?=
 =?utf-8?B?c3QxL2VhWEFwVmR6emtwZ29vbHRRWDNBYkhMNW83K3ZsNEhIclNyaFFTeEly?=
 =?utf-8?B?L1VIbXcyU2FaK1o4SXBjTHo1WFh0OHBjOGVUY2s2OGoxeXFkSFRkb0tHL0Nl?=
 =?utf-8?B?YXpNSHRUVExEcEpqMkIrMlIyTHJnYjZNZjVjdFJvTnNTWXluWTR4bnVuM3Y1?=
 =?utf-8?B?dHJXOVc3d3lpSzAwc0dmMDgrQVNkZTZTRnlMbFhIVEw4V1pYNnVGbjlQa3JL?=
 =?utf-8?B?MjZSWWdtOWdLL1Z4WU1wK3NqVjBHL2Z0MSszYjA1Wkd3a3lkSGJWbWI0VkJm?=
 =?utf-8?B?YTJkUFpYVkVCQ1B0TkRHZW1kNExXYmFnYXZxdUdKcUwrU1lqd2JTUlNwUlB5?=
 =?utf-8?B?cGpWcDAzR3lvMWFpSGFNMituNEFpenJSRC9OM1U0aWRRTU45OHA2TVFKTXky?=
 =?utf-8?B?N0IvZitER3lyVXBEVXpCOEpNVkdISWgxc2hXdkRzK1Y3NGNBVmZhd1F5NVFX?=
 =?utf-8?B?WEw2T0ppTmtDelpsVXJtN1AwRzRGOTBFUitRNkZhSy9BMUlXakJuUXhULzhi?=
 =?utf-8?B?VTVRUjU4Z21VbnlaNm11VUQ1K0J1aDZ1WGtSVm9ySHZjeXZVYlBuQWZiSU5r?=
 =?utf-8?B?SlBPcFNXbVdmM0FYTzZSVWc1d0kzOG5pSURUNm1sWDN4VlJPOUE0UTArVysv?=
 =?utf-8?B?dngzcDlMK2xRcHRvb3dOVkVBQU11T1VSeEErUWJaZWhtKzRyanUrdlZlZzRR?=
 =?utf-8?B?UzJlNXQ4eE5oN3lhWDVmNUM4OVdPbWtyOFppUFBIRlpwT0xNQlF6dXJSR284?=
 =?utf-8?B?S3J6bGVxR1FaQjQwb0FKNXIydFRROUQ0cWY5UjZLazB2WTdUM0lHVW5BdG5w?=
 =?utf-8?B?aUNyNWVJQ09lcTlHbzY2SURkakV1bXhubEVsYW1UZUp1T2tCdHJ3USthS3RF?=
 =?utf-8?B?bFN4NnVPS2hmdDgwMFNyaEdFczRBanV2WjdNVGZ4NmFGQ1ZlWVFkTkUrakZz?=
 =?utf-8?B?ZXhSOXkxSE95d0N5RG14cnZMcGZPRk81eDZWdkhhZ0JWTW1NMnlNSE80WjVx?=
 =?utf-8?B?NTF1eUZvN2lDbEVHSWdNVzJzc25pbXRIYkhDdnd4K2FSY0ZoZjJVQ1dJUExr?=
 =?utf-8?B?dUVSYUIzM1lNN0twSE9rMWVXTzlmWVhOY2t2OVRHdUwrWWFMRWpqMXl3dm1l?=
 =?utf-8?B?RDdoeEorQzVkc1BxL0IxNkNIL1BYenpVd0x5THlRU1Y3UWdtZVBrdGRuUW9H?=
 =?utf-8?B?OEw5VS80L2REY0pnUjhsS2pSVHBqTlZ0OVhtSFpGWGc5R2dJbDR4SHhNNjRZ?=
 =?utf-8?B?Z1NGcjlWRUhEUlhhck0xdTUzUGJxeTMwTlc3Q1pSZnhWOU1uYWx5ODNIVEk0?=
 =?utf-8?B?blV2VXpLamtBUTRQMzdYT05XekFLWEt5M3phaFl3emNXVUZLYzVUN2g1c29O?=
 =?utf-8?B?MVBFK1dWc2wzZHNBYWJvQUpqYXYveDJmS2FPMDBRUUFtdU01RWlmMWNlNTQv?=
 =?utf-8?B?S3RPR0NVUHF2ZFVtbmVQV1FLa3VXS3luZ0FiQ3dnYXJYRjlaakdjZWFycEo1?=
 =?utf-8?B?Q3htMFozbG1CUVlsbVpOUm1KWE04TzJxMFNyVjRLSmRJS3lpdXRiaEpacnRC?=
 =?utf-8?B?RTYxbmJzODVleU1WK2h5Q2JIL3dYbFF0YjJkZmdiaWRCcHVKalFLMk0rOU1s?=
 =?utf-8?B?SE9FbHZFQlFqU0tSWXliNjB1L1ltd1hYQlh2cnVaQzhHaXlxTVQva0dDZWNZ?=
 =?utf-8?B?enJIUFprc1czQzN6SWd6QUJNZ3FheU1FZHk2SG9hRzVWWGVUTFZBTUFyNGVB?=
 =?utf-8?B?TTR5VUxBT0NSS1pUR2JuaDVVTFVMU3NCM1dWMnJNaU9zN2NSQzFGSEo3NWRY?=
 =?utf-8?B?NEY3V1BYbUx3SDBaeTZzZ2U0M0RiS3FKTE8xN3hpV1NhM0pCS0p6alBBcVRZ?=
 =?utf-8?B?MFhPeW94L1ZWMkhFUWI4dVl5ZnB0NWV1a3Rqb290SVJuRU11d3AzS3ZNMGF2?=
 =?utf-8?B?S0ZZOFR1S1ZBWHNlWXZmVFQyMGhHTncwbkNtMHpHSmFlbVd4Q0pYL0FWeHo4?=
 =?utf-8?B?bDhqR2czd1djQmxnKzN2WmR6NUU3VXRZYVlITG5nZFcwaHhyMUpqaW1tcldz?=
 =?utf-8?Q?4b00=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGtwYVFRUDg3WnhNNmwvemJ5cW1kVkt6V2d1M2Y1cUVwTGIvQ2dERHN2anBE?=
 =?utf-8?B?dDEzd240NDFSZ2huREp3cktxait5cllNcFNpeEQ0L2FNUTh5QjhDWmQyQ3R1?=
 =?utf-8?B?dCt2TjVGNC9ZSVVtQnhMdUp5T2RzK0s0UnorRXFSbEhFbUVnRHVjL2NPRUJW?=
 =?utf-8?B?RUFyNUdhL0U4RERoYk42NC8yZENLa1lhZGhoUVVVQWg3djArRkwwcDFLcnRX?=
 =?utf-8?B?Q00xNTFyc3NkMitBMUh1ZzJQLytTZjVvaFBQQkdiOC9DbERCWU05aEg1Y3NV?=
 =?utf-8?B?WlpxMWFBSEFFVFhialNtNktUcnRDZ2RTTnpOL3l3MXlVTGVRQXBIN0hQM2tW?=
 =?utf-8?B?cCthOFY3YW0wRzB1cC9NWmZoVWE2T25mOW9GTkZDZ0R1TlFwSTJKV2p2ZS9i?=
 =?utf-8?B?ellvUXdreTJuQ3k1d1h0bUd3Q3Nia2dNK09obVhlMEhJN2VONis1Q25MR0xU?=
 =?utf-8?B?SEhJMG03YnIrdDdIa215ZEsrd1pHY3orcE5nSDVpbElpSmUyVTV0VFFGL05F?=
 =?utf-8?B?L1lJSHh4ODBnY3RKT1lMRllaTlBmcG1WOWNiSWNPZ1RnRGY3UklNTGQwYkVv?=
 =?utf-8?B?NUNiempCOEQ1NU9JUVFJbUxNbVp5N2NPVHNJSWZuSFRBSW9nang2cXJOclBC?=
 =?utf-8?B?YnNmVzl0QXl2bWRXSmVGNGVoejB0bXpDK3NzR3pvbW91elVtdEpZYzQ4Q0E4?=
 =?utf-8?B?aHZUUXdZK29SdUhXbmt4V3c0Sk5WNWJzTmdXdENMVjVXcTd5VE85K0ladXE2?=
 =?utf-8?B?NThGK1ZsMDZuclREeU9qa3ViaURXWExjOWdPb2J4alZ5TG5VNE85T2lSVlk2?=
 =?utf-8?B?RzBpbnRuWnNJTGQxbXF4M3VpSENIbFpGUW9ZeDZSZEhsTVVqQnI5K2pnWGNu?=
 =?utf-8?B?eUQ1UWo5N0YxclR4Z2xHdVI0TGhHeE94TE1nNEdabXJCbWJHaDJ1Z2cvajZW?=
 =?utf-8?B?Q045bDlCNS9JVU11MmkzVlI2MUZXQlkzbXVYZmx2MGwrSkJMQ01NUm9WWkQ3?=
 =?utf-8?B?LzUrWTUvOWkrMkFqVXR4ZWJKWnJsOWhOUDRFQ3U3anpJa2RlVzNXK0Zrc2E5?=
 =?utf-8?B?VFhsU1VhVlJ5Rk5TSXFKZExVUGFmWlB6cDVkbGpYUmZxT2ZVWnpvZnMzbTZP?=
 =?utf-8?B?b0RzNTFyaTFTVmVvaUE2b2Y2eklHZXd2UndqLy9JbzhpYS9PMTZCb3lYK0s5?=
 =?utf-8?B?NHd6Nnl1S085NXJoSFNUVzhqMzdhTzA1M2ptQUFUSzlNMG9pNWp3Qngzcm9K?=
 =?utf-8?B?WHNwaG03a0hSK3FzY0c3UDlLOXpweUZ0dHJVNGhkVFZKTlhkamNSYkRYYjBu?=
 =?utf-8?B?d2ZWeVI3aHh0Q21GWDEreVZ6dGtqNEtuSWhDa1piT2NOYTl4N09GNFFOcDVw?=
 =?utf-8?B?S0R2U3VZTDNjTWdnQzhsb1ZvK0lQR2VFbzRQMldwbDU4UExIUi9QRnJvOVZj?=
 =?utf-8?B?WFB3MENtVkZFelFkL3ZRVTlxcE1MRzZEeCtTZXZacXVqd1Y5bUplS0dQb091?=
 =?utf-8?B?TGdScTd3MERJTit5V1FYZ01FN3M2a3Juc2JGQmljd3FZaUpKYkFCdTdXc2tz?=
 =?utf-8?B?a3NGTjB1OWxmOUxxQWM5V0VpZWQ5TlJ4M3ZxK3lCRDA3L202czZLZmJYaDZv?=
 =?utf-8?B?bWJ2WFI3bHBqODVxb213eWsrT1huOWhVVUw4dmRnVGxKZmJOb0FFWHY2Nzhp?=
 =?utf-8?B?TkhuT21OL1M1c1dOdWZ5dnR4NUZoUFh3UWI1RE14U01iRjJoUlY2V254OGNx?=
 =?utf-8?B?M3l0Q1NXZHJ4U0lNMlRvMm1DMmJsNnl6MUZDRW9kekhKNXNrcmhlMkNYNEpQ?=
 =?utf-8?B?aUFEa2xEM2hvRmx1dTZaakwvdWVoYVhlRW9qMy9wak53UlJseWZRZCswdmtr?=
 =?utf-8?B?MjZFREFHYjc1SVp3Ym53WmhkNi9qNWVVc3dXTy81MWI3MFdub3VMQTJ0ZHpv?=
 =?utf-8?B?RnlNQWd2U3c2WGpYMzlTbGxsdWZVT3RtcXl5SG5scDVjaFRyTXM5cmZCZ05i?=
 =?utf-8?B?R3RhUFB0YkM1RDNrS1lPcTRkZ3dBTjJlWlZKNFRwQXdLWXBhTjFkYi9WNG84?=
 =?utf-8?B?VUdZWk1zU2x2MTlsdmR2ZjJEbk1NRCtzTzVqbStob1owUHduWGRHVFU2SFdH?=
 =?utf-8?B?U3l4K1dtUUh0WlZNZXhKTlZlNmVYUSt4WjN0VnQxWTJvQXZ2ejBSdjAxMGh4?=
 =?utf-8?B?MzJ0bWVKL0FhSG42MmwrZWF3WVhjSDlvMlpYRE1BRXBsNjJ5eFJFVGFYdFZm?=
 =?utf-8?B?N2xpSS9rOXMxQ1BlT1N2RVY2YnVlekRNeTludThLczBXcEQreERaZWJsd05j?=
 =?utf-8?B?NW9vTkhoeC9EZmNSVDBkYmhlR215RHQ0U2o2OFNMeW84V3BDSGtxdjJMenVw?=
 =?utf-8?Q?nP4QLvZSu7IubnB4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iUyK08ZJ2rutKwq1zij4A1EOv1c1BHU7wkAW2f34R8DtresvaM0sl+gxKfAmZEZNOFn0bFGHBsD65dk5p/7r2SDOTYXM5Tgryi8aTSvd9Qwyt1ngDkzEmQGj7QGmAgmq1rapY9bN42PiS+glD7ZuAAe7dMT0XtHNm0HXzhhnCk/14HTBWuk+EpN2Y0Amu7HNFcSEpUkYIt7+IisPDT2RsM3Oj2oyhGfJNh1GYOklLBPfboPhB9Jb1wrotgBvFvNwp3YmFYnR1spQuWwnaiP4ABMX4yzTrs9VyaZoZr6VMH/ikBKeIs8e7PtG/y3fAIMs86do88VGQaBcjTO7Id1slkb9iQ0iqViNc5lCyMIqgZHyhpag92t6WQrZsm9k+/UDaArUrDOQBmcd543I+tSR31yp8el+SVOAgVyjiEMYCgBUBX3AfIxQetOd03qOY6RF/MALwfdJ7RuWw9exi5repoFVr/OMJ6n5LDxNPBcIo3QGarzL++Y5OHVKD3Usg09fxoFroMdIVSyk4aG+mFUvkf1OaaByMu/3mlmS2f7qMkrGm89f9K/gd6MNLOcxiwYLxkDTPFUQhBqC8bdXJBvvAzBKsslk/Qr4q9cpDWLX2lI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4b4883-c261-4c6c-701a-08de5aaf7bd7
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 18:44:47.7672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0VI4m2rOa5yCFHGCkfNFWaHN6BCYSHd6itqARTlK7UpXIpct137cgDTja6BpOU8/ju+uXlZbnLg2O4kkxGKm/az1p/ymBv3YnVmnmriLmAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230142
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=6973c1a6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=CLkusZBIhmaYX332FuIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE0MiBTYWx0ZWRfX9LJLN5+4vUP5
 a2FE0viqvvRSFHCoP5H5cCQeYkwmT1S+mwzdSCMlkz+cyTmxg6JNAnZUn7eFXEC3RAJrMIbFVu7
 TiLqZYMR+EDzeOsl2L5JppKGrU+hIJEkQCEfaFmbdwdmD+YFgisn/KOMo1CY0AMzNDdAlH7EGif
 56SPHJnRuTP28D/HnYL1t2ykeYLRz8p6OIfE/3jznyRYzI2sfvL4rmDjqJNd3fdsGCezmJ/lZPG
 BFkgT4tsze991ahT1DVjXgDZdOzMasTMAxsl3ZApdxjt7kAstkgZC1Oot/y6uaGmX73YbOTlVBm
 dzgjUiaJvMoyFOpMwzpVf+jOBc71WaA1UF41GF4aj/Ftl2IzOoBzsoKFbn+8PJxmWRviZhlWGnj
 YI+xV+lEjpE860m+A2/6PqtAOHaTEj/olU0UUSNXtYxSVUlMcWQMLQy+/w2GvdtS2ATU/pbWqmT
 NjgI2ljVu0cZxS+86cw==
X-Proofpoint-ORIG-GUID: gFOcNnd_wqmAhZB8YzEE1BcSXCBcqgda
X-Proofpoint-GUID: gFOcNnd_wqmAhZB8YzEE1BcSXCBcqgda
X-Rspam-User: 
X-Rspamd-Queue-Id: 5353440006
X-Rspamd-Server: rspam07
X-Stat-Signature: 7xtixjeutrknhj7pr5y1wuu9iuh318nu
X-HE-Tag: 1769193909-580169
X-HE-Meta: U2FsdGVkX19SYSmcNiinAidRAXmav6AISXxcOileDbHiYBFiHJJprXWWn12Kgh4va1zIWWjAioQpLZRJtaw/XKs8GtZwDwvoZLSHuKO4kg1mt+ur3MOReZJ2yaysAeMUnk53hxe8mroRjPiaDbObF1KMkxOeCLG4zY9i2606ZFsXcY4jxtK5u2tDeCdf+zMqjzzD5aX8Y2ISroYcrbTC5bQ9mczqq/dZjjrPbFTyNHHskzl4AdniMeWCA2bevjY1mvoUaD8Abod5VbHrwei+FiPd7bqqRqvwJsjRiTIdEwSKHodXXnLrX7jg6ubZ3jxHg+NiDeHjQRTKm0iOzIvesJSp8IJ8+PnDV/xD7/XCucUEQDnX1+737/tZ0KAHGjfTeqXRBzJGvHJRxW/F4KOHnmRJU3rbLbfJO51VVdGTJd+iD3tuF0ZqhNz+og1kIt1bh65pgxCHdZBKNvwaokYaFX//WrkkJ56XnJkhBHCPDEYq+OKu4e3+RVETG9L94TePY3tcrihfUFZ0PJrwanPHd1xPIBrVIed25rv/6c/P49BdKfPUBjNLotawfIiPn0gRD0Lu55m/UThmCAeZFtqjNqe+bXpW4X6nJMupvtuzaTnY+I0GWIJBu1/1txfllyGjE1/tCHxEG36Vz2Vvpwj2PPIuvjv2iJbbna0q4e5yChSqehjv1uRuCjh5LTcJiWHJuXBvHhC4G2yyBgwLelk9yNnk5fU1X0rNGeBp3hXIsWs+T/50GM28DFTYfdjKV2qSwrjwBoTzXmIbHEsSTMQ5NMxpBQWmqH/BKrVUhCnNIiQIF3Q+IS7k8GVPaaXN7eqUpvqes4nZRwzp2X9zE69sAZ2m8CjbumgJfeMCSTrR6MhKNk1/kAHkMb8gI1iCScADOJYf09zktQQeiWQhMd/c0I+8Vyy4ODs5ENXKdPvwSDH8BkomvqERdNIXUZrF79Zpxs5pwH1hhrxO0A9y3RL
 t85W/iHV
 kcyuXoY3NbwFla0G+8Xn85Y+d/fWISlemg2LO2Bx29vu8KRifAAcoafrKkikznDMY7kCezHIHOiOjIjfeiVc96Z/H9ZMl+FW+34fv2pBt4uVLq2BiFZUfqDII7KO+s70X7ASpL668+dd0Hy3wy33yAWfYy8FsXw8CA57z2Oddp+hCGtSGAKC6NyYfgwb8cQv5sXpYWqQYp90lhPrLBVGHScgs9JpRHT/KorWz6YWjTGLbPaFFKT+RiG6RTCPb4AB3GavFxBWQfzDZaT4ZACCITLq8UZjNRjit7KAzujlaCXULBR4TzO38nyS89qGUrGqcynqzijcZXSA357AsolF7W+oY5fAy3Gj4Any+681vtuISFdbwZ/HpU0td9bzVgsIGSDVnNF9Wk54np+to+zQuzyQDrI0vUp1DPkbmvQJRHr5RJXRRZ0GD5xGpEPEmk/Y1WY9A9BcoaxALaw67fznZ30P1iH3wHsOrZ3CT59cxCBReDy8wvp1j9zA2U4OsFeD9FJYaYr3NTq7y3PvmGjrCELtczz5KQ0kmUoibu4nYcGT/Kpfd1QWoFGpwocIH3UQhzXO0aveb+tOC4Qk9c0BsvHUm6xdyJRoK89VDttO0R4S5WBcspy1STOq2dVW+As3Y1lshe6fX3zC9KDZp7GOGiHO97ZYOUUWKTj1QPJrDBzsMKoknii+JhQuUxjgGMLvmSEkJ+S+CcunhttART0p9U/T2v1rjkFwnSv75iXVQDFk7UYzy7xhQgUHu1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 05:21:26PM +0100, Vlastimil Babka wrote:
> On 1/22/26 22:55, Suren Baghdasaryan wrote:
> > On Thu, Jan 22, 2026 at 5:02 AM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> >>
> >> The function is a little confusing, clean it up a little then add a
> >> descriptive comment.
> >
> > I appreciate the descriptive comment but what exactly was confusing in
> > this function?
> >
> >>
> >> No functional change intended.
> >>
> >> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >> ---
> >>  include/linux/mmap_lock.h | 23 ++++++++++++++++++-----
> >>  1 file changed, 18 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> >> index 873bc5f3c97c..b00d34b5ad10 100644
> >> --- a/include/linux/mmap_lock.h
> >> +++ b/include/linux/mmap_lock.h
> >> @@ -252,17 +252,30 @@ static inline void vma_end_read(struct vm_area_struct *vma)
> >>         vma_refcount_put(vma);
> >>  }
> >>
> >> -/* WARNING! Can only be used if mmap_lock is expected to be write-locked */
> >> -static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
> >> +/*
> >> + * Determine whether a VMA is write-locked. Must be invoked ONLY if the mmap
> >> + * write lock is held.
> >> + *
> >> + * Returns true if write-locked, otherwise false.
> >> + *
> >> + * Note that mm_lock_seq is updated only if the VMA is NOT write-locked.
>
> Could it also say to what it's updated to? Or is it too obvious?
>
> >
> > True, this does not result in a functional change because we do not
> > use mm_lock_seq if __is_vma_write_locked() succeeds. However this
> > seems to add additional gotcha that you need to remember. Any reason
> > why?
>
> Actually I wonder if it's really worth returning the mm_lock_seq and passing
> it to __vma_start_write(), which could just determine it on its own. It
> would simplify things.

I mean don't we have to worry about racing vma_end_write_all()'s?

I suppose not as you have to have the mmap write lock here exclusively, and
we (lockdep) assert we own it, so we can probably safely assume the mm
value is OK.

It'd be good to drop this parameter.

I see Suren approves so have done so... :)

>
> >> + */
> >> +static inline bool __is_vma_write_locked(struct vm_area_struct *vma,
> >> +                                        unsigned int *mm_lock_seq)
> >>  {
> >> -       mmap_assert_write_locked(vma->vm_mm);
> >> +       struct mm_struct *mm = vma->vm_mm;
> >> +       const unsigned int seq = mm->mm_lock_seq.sequence;
> >> +
> >> +       mmap_assert_write_locked(mm);
> >>
> >>         /*
> >>          * current task is holding mmap_write_lock, both vma->vm_lock_seq and
> >>          * mm->mm_lock_seq can't be concurrently modified.
> >>          */
> >> -       *mm_lock_seq = vma->vm_mm->mm_lock_seq.sequence;
> >> -       return (vma->vm_lock_seq == *mm_lock_seq);
> >> +       if (vma->vm_lock_seq == seq)
> >> +               return true;
> >> +       *mm_lock_seq = seq;
> >> +       return false;
> >>  }
> >>
> >>  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> >> --
> >> 2.52.0
>

