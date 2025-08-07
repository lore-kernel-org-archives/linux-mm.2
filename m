Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E26C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 589FC8E0006; Thu,  7 Aug 2025 15:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53B088E0001; Thu,  7 Aug 2025 15:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB7E8E0006; Thu,  7 Aug 2025 15:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7688E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:53:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE1551378A0
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:53:20 +0000 (UTC)
X-FDA: 83751010560.28.E6B1991
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5120F40002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:53:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nf9Z4Y3X;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ojic37Gh;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754596397; a=rsa-sha256;
	cv=pass;
	b=eoqYr4GWgGAMzLKihE+SUF0m1TgaT30HEQvNnVfhMptsm7kQ35w2NZEpp26Bzd4tFOghV9
	Dh2QNzgxvTLlRvSioiD+QaVSWIpUh0Q/pLfeNJRTM+4x8pU3ylFrQqkmFXf3A/8IlpYOrf
	Bw+Ricex4pN20H+OVys+qndDgktZgfw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nf9Z4Y3X;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ojic37Gh;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754596397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vO25llXA01q/5ZHkq8ethfEfAA5xanBkicH16GSB65s=;
	b=ttURZ5TVww1Y+35SyDESoDnNvFQFdL/RPOCC44PMhSxqNXKVYM/NT+UBYshCpZF8FzG6d4
	EQFsBLLOOhHpERojtG2fFpph6N8URdcfT3k0yi6qWTvB2LzCDOjhodU4ubL/VnTrZ90uW6
	AWVpj7Biq32/vlO8Va/R18vvvhGVamg=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577Jfwd3025413;
	Thu, 7 Aug 2025 19:52:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vO25llXA01q/5ZHkq8ethfEfAA5xanBkicH16GSB65s=; b=
	Nf9Z4Y3XdMnJcqzawQgbL/58UByE2BIkTp21siLXgzHO2hNvfp9bRbDd3L1Moi0U
	0XuMv8e3wdBCTDVdzIV7rnOk+bS1KJfR5CoGfXfAtbsHjR29xMHhPL2d88zG/1mO
	5exPjFyE746fmpgpqhUxrj/92hfVR11qF9/BOHju77+tRe5p9zcXJZTQOXGOMC0y
	nUGNnoFu8jkp7mplgAk7cx9BUqeztrwgOc8aVanI/xREr9WocW0yrYlITV1NC99/
	uU3SlDyJun0vWZRkb4L+B6gdkrY22WG0C6rmOB9IhHcrY/TOZo4TivjyFYb9yBGR
	XrePuNsdjskqm7JMVAc4DA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvg4xth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 19:52:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577JjhcX032127;
	Thu, 7 Aug 2025 19:52:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwsdqgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 19:52:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UwDcvha6r5JvyyS7Wea883H6uG9CY3Pm8g4DAuiILS3qPhb+l8IqRd9yYl2OXRnL+CGl0vwqMYyqBC8PAa1VarUbuaNKAhQ8eBoaww+dcHsI5a/oApkR5kiftlFxSkUzIdvBR4lcd5jgxVOE2b19cgbyDh9ybUG56le/JC1mArWpMHjzgJBWIf905YiM+QniY93fXvFLq11xsVjvqxhrUvTaTQVFkpaXd2FJi2qITJJcU8WCpxTPiHX3sNMxzMnVntu1WJiCth6qrc8NwzmSrkQvRS5Vaq0UqdRsGvpVhCMsRUEeAsEPgKrfgbrQBIpDXHVcocIAAZyiPGoXRCEgMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vO25llXA01q/5ZHkq8ethfEfAA5xanBkicH16GSB65s=;
 b=M5WSsnbrIY3xZrRRlXjHCueUm+iM0T7SM+gKI6NxEdh97dIoH15q49vFjnEScZPEWoPJS7ptxYx/WSKDNL47EpyBcg2xbc9o3RWfN7hhDrWrxBSUxas74X05LgK1Kk6633QpxJLivV5ky3+a1X6+NuxZwDbhr6Y5agMOfAFUWFm7gM+2g+mjdkseCT390dc1p/7nyx6dGXNPPaTnW1g0hRKV9sCTrlFo+3v8hEpImLqUhWUd+QuKIaduJoH/YWo1I4Hna6zaDHs3CFUIzUACcOmzHHwUhpX1sUpOcbxStkMX5WjXukea3d7lXgbUYNEJsFxwRfpSmAe8IJhFuYbBkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vO25llXA01q/5ZHkq8ethfEfAA5xanBkicH16GSB65s=;
 b=Ojic37Gha7f5YdVYKqZiPvV/BJGWrD78ydiMBCcxExn6trHmkHSK2EZbYOSOxtZt5BqSYP2ZEfzJynYII+UMplAjSGgZ9uElXasMz4n3NkFJ3Rd2brhdNv5t/S02SXSiF3rGhnKuB/UNqECt4EyTC1sryQYLWcgsa5+kOEs4aYo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5780.namprd10.prod.outlook.com (2603:10b6:510:149::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Thu, 7 Aug
 2025 19:52:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 19:52:49 +0000
Date: Thu, 7 Aug 2025 20:52:45 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>, kernel test robot <oliver.sang@intel.com>,
        Dev Jain <dev.jain@arm.com>, oe-lkp@lists.linux.dev, lkp@intel.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Barry Song <baohua@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Bang Li <libang.li@antgroup.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        bibo mao <maobibo@loongson.cn>, Hugh Dickins <hughd@google.com>,
        Ingo Molnar <mingo@kernel.org>, Lance Yang <ioworker0@gmail.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
        Yang Shi <yang@os.amperecomputing.com>, Zi Yan <ziy@nvidia.com>,
        linux-mm@kvack.org
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
Message-ID: <c170282b-be66-4eb0-91bf-17614acf3321@lucifer.local>
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com>
 <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local>
 <CAG48ez3=kLL4wBxAVSa2Ugrws+-RFQMdNY9jx5FAdbhpNt8fGg@mail.gmail.com>
 <e4f5faea-ccec-4cc7-83de-1a3c7013b81b@lucifer.local>
 <cbc2e23d-69ab-4820-9942-c7abf2066ff7@redhat.com>
 <CAG48ez1vM35DZ=kTSd4+ndgR6y33AodLLC2KbfbhGrkDaqdnNQ@mail.gmail.com>
 <d8e0f3b3-6ea7-492b-bb94-4f5d1ab28ef2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d8e0f3b3-6ea7-492b-bb94-4f5d1ab28ef2@redhat.com>
X-ClientProxiedBy: FR4P281CA0210.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5780:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f326be8-0fb9-4ceb-3643-08ddd5ebfca2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHFhYUNkcUtZOEpYZjZkelo3KzlGRkNqcytIRVBpa1FrL3FDKy9zR29rNzVD?=
 =?utf-8?B?RjdwK2RXdzJ6TG45bGg3alNTVlhSd3pDalY4QlZrTWJOWFV1eUVuUVdBdU9k?=
 =?utf-8?B?SW1ueFlMR05wTFZHbTBmZ0FYc0dvM2h0bzZ1eE83QlFWOUVqZ0M1dTl5WGg1?=
 =?utf-8?B?T2FmT2h3ZTRCZUtjYktoQVpSaVBMbmhQcjhjRVlzZXhnQzBKWStmdjFlaTcy?=
 =?utf-8?B?TWhFNk1UMUhkVGRFSkI4SDdmTjFvN1I3TDhyZGtSb2g4WnZGeXptNXl1NUsx?=
 =?utf-8?B?U2w4djJtK04vUHdweXFKa2s5RURoZThLaVlwR3JQTG8wOEFZNUN0SjdvT0N4?=
 =?utf-8?B?T1d5cmhsM1hBSE16ZG5OQzhsc0E0dFNNMVBvM0M2ek9pVFc0S0ZNQVJJVDZu?=
 =?utf-8?B?TkkwaytyM0JnUFA2Y1llWHlYOE1WZG9jVWRjc2U5WkNncmlrMUd5cUMyNmFG?=
 =?utf-8?B?Q1JZdkVzSzVUVUtlRUtQbHMwU0x5ZklYTWc1dGFHWmhud3JpUmtoVGhKdlNW?=
 =?utf-8?B?TGM0azV3VXdlZjhpSXpiWE5TcmR4VU55UzJ2WGplcEd4SXRwenVKR1loZkxS?=
 =?utf-8?B?WjhWZnFrS2RxSDM0QllEbTF0akt4QUZ2R29zanMrM0d6MUYxQ2tXVU9LK1pa?=
 =?utf-8?B?UU1YanlGclhYWVBHbTJFa2hna3EyeDdDdWc3VWRzdlFON3dXNGdmRDU4OGJi?=
 =?utf-8?B?Q1lKOTcvVXY4K3N5SDl3Y0FSZ1gveDFlOTJ6V3oweC80akxvTVhKRnhwVXFM?=
 =?utf-8?B?aGluaFF0azNlQk94bXdISHFrMjhNQzJ5OHFJWjV0ZENtcDlCZ2R4UklXSWJQ?=
 =?utf-8?B?WlFGTnRnQXNFTWxNSVIxRThzZ2IzbFRld1N6cTV0T2RVdldVMEVqK2FwTTZP?=
 =?utf-8?B?RVFEVVg3UmJ4a1dsQzEzaHRqL2tLSzNMT21oK1lIS01FcTVnRjkxcUZGQmFa?=
 =?utf-8?B?VnNHbGMvN0k5UzI5R1BxMEIvZWhudVZROTA4MmJkUFRlSWpyTDRram5rSDYw?=
 =?utf-8?B?OHRsRUUzZ3g0c2twb3ZOWmZsOEM1alZEaVRFRnppSnhvWkNpRVdYOGJkN215?=
 =?utf-8?B?QlRYQjkrMmJnWTNvRDF1TG5JWmxBM0J5NSt5aEFhOWRtcWVwMkhHUW54Uk1R?=
 =?utf-8?B?Rzg4cXhZaXNDempqTFFFTE1vYk9MazQ3RGdXM1lnazR5VXpHYnhmeDRyd2JE?=
 =?utf-8?B?U1dQWFBkU2FxcEVyeUd2WHdCWmhJT3VzUnRlRzh2MTZDYS82RDRJanpQdi9p?=
 =?utf-8?B?ODNDTTNZZDJPK01rTEdRVGJHSStyTmJsTUpGaFBmbXBpQkg2WTZveURkblAx?=
 =?utf-8?B?eVRuVC9SaVBucVNnbzlsR1JVc0Q3cGtLRmZXV3RDejF3amkwNkFTU2R4YWo3?=
 =?utf-8?B?WEYvc3ZIZjFoWkJRZG55TG5MV0xXUHV1VVduOXoveXM0WjM3UDRDV25ON3hX?=
 =?utf-8?B?WHNGZXlQNXd5WCtoVHFBQUFEYzMyYlJlbldTRTh0bmhrMk9xeWZsc0VqdC9Y?=
 =?utf-8?B?aDEvdUVPY2piWXNKS2pxaGowSGhFR24xMEF6TFdIM3Q4d21XV21mUUtHRnJV?=
 =?utf-8?B?WVZKcVl4dmpseEdtZmN0ZWZUaVVwZ05MNWl3TGhBYlg0YmdlWkZJYlMzM3B0?=
 =?utf-8?B?L1RvZWRrTEtZbjdnUmpMRTNaNWlzaVVhT0tJbVVHenN5ZXQyTW5xaHlrTXRF?=
 =?utf-8?B?OTNQSE1oeHZmTVJVVzBwcVN1ZEI1V1JsMDY3KzE3akQzU2NxY1RMVkI5QWdx?=
 =?utf-8?B?U1JaUzcxK3cvQ0xiemgvQW9teFBiOFRZVVRBY01XTlBtZ1JMSnp5NXJLWDZq?=
 =?utf-8?B?OVQ2dDUrbG1DK3F2WEdNREZybHFWd2lCYnJKYy8zRFdINGJNdWNjUTIvQUpP?=
 =?utf-8?B?QUt5TkZGWjhMa2h4NjZVekZCRzNldFJrcUlQbUhQL3JsS0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWpHNE5PMkVlSXRWNVArSkZ5RjVtYWNkSXpCT29iMStSYk0yVGxoYzVMSXpO?=
 =?utf-8?B?MmRUNXFhRmhMUVArWFBCTlJzbWxSMHBoczVkM0VQSkR3SzJEeXZTYmZ6MTFw?=
 =?utf-8?B?TUZ2U3k1dWx5anlMUkEzdWVCbDVXUE9WK3pSdGYyb3EyZ3BoVFBsZVdiRU9w?=
 =?utf-8?B?WTh5RFpxMktWY2E0TlhxWGJ1L2EyK2c0ZmZSRGxYaVFVN096cEt6blRCZVY0?=
 =?utf-8?B?TkY3QlFoTTNncE9mR0h6VGpjMUluZXQrTmF1VmZiNkk1K01meTBKbFVZeDJQ?=
 =?utf-8?B?Q2hkdmhkdTZwK0NXb002dzFSZnVEVXMvSEFSUTZFbGNBVGhMTlhPY3EwRHNs?=
 =?utf-8?B?UFlOU3FCNUhRT0kwRURZdDVwd3FUVXBkYVA3Y3kvUEg2ZU1Mbkh0eXFwNUFU?=
 =?utf-8?B?QUNnVG5CamFsSmhNdFl1QmdDQ3l6dHpuZjUrbFZnOFJMOEpmS0x0TWpQMEJt?=
 =?utf-8?B?ajVqU0UvTE9BSXJmK3RsUUpLSWZtRmVlUWNNMlJVNGxteUR6YXlZVlV0YURY?=
 =?utf-8?B?V1FjemM3UjNhclRHbDAyU2x6TUFpcWdjZWs2T2YvZy9hWFAxaVpDbVZIeXhH?=
 =?utf-8?B?Q0RCeDFCVERXM2tUQW9lWDZOSTB1Z3Arb3VzQTNndWl2YWJxYWVDZmNHU0Rp?=
 =?utf-8?B?NFNIKzZNcFpKd1hNSG11UHUwakVoU3NoVVdGa241L3JwZ0RjenRRYng5L0ph?=
 =?utf-8?B?a3VTT0JqOXhhQ2ZRc1BSK2xlNXU0TkdLMG5qMkV0YndaVDdaUSszN3Z4Wktt?=
 =?utf-8?B?c1BJMXhRbGtHRk9kWW9pdjRWd1JCZGEvOUMwRXBVdnhPRzlnWWZTaDBPNXlq?=
 =?utf-8?B?S1l5WHRLUkV1VkRmZzZsaEZmZGZwOENiY1RwbVQyclZTeldidG1MN2FsaXNn?=
 =?utf-8?B?MDcvckR5ZUNOT0JrSUFUSEUwUGpEbGxFQ09IVTdnUXJjU3ozL1hKSmU2d2VH?=
 =?utf-8?B?QVg5a2J4N1Vnc2lMcUkwSWZpVGhmMFVpT3FUQ0xzNDJnai9vM0lXb1k3eENY?=
 =?utf-8?B?eEdCMFFpTXBUWVBlZUdIbWYzT2pvTGZZaldjcUxRTHZvWXNNME5zakc5S0Fk?=
 =?utf-8?B?WXRtQ2pLU3FCM0NTMGJhMWxOL3dRWGFpbjNkTitkUitFQWZuKzlvMWtBSzZa?=
 =?utf-8?B?bDJlM2pDeUNUYy8zM1BPVHNYaDhxQit0WmVOSnhFSDkzTlFHVUQ1Z2NEamFF?=
 =?utf-8?B?ZFhuY0dVb1MvT2c5MzJ6WVl0c291L0lSd1h4dTUrZWxWdkVLeHl1RnIrdlpY?=
 =?utf-8?B?UlFOUFhJZkQwVUN3VURQak80MmxSUll1VkxucVErdDhkRDVKdUljM3pzOVZ5?=
 =?utf-8?B?aEhDV2pRUWFnMzZFOWEveHk4S2g0VHA2aXBPUlgzdmsyKzRLU2FaQUEydmgy?=
 =?utf-8?B?NzhQeEJrR1JPZHF0WDRQSUxzM0cxSHNGOHM2Y0pBRFpuUVd0cXpXeTFZM0o4?=
 =?utf-8?B?YTV6clFYSkg4SUxRWVpRdC9jMEY5a2RqWkw3QWpJdzR2Z0trRTJybkZUVkxl?=
 =?utf-8?B?bE90MVFLZEN0bCtmdDd2SWlXc2ZTQWlhTXMwd1dibjNORWt6a1pSLzhZZk0v?=
 =?utf-8?B?Umpucnk0REtjbTNmazlJSkNSQ0xCY09oN1AvTzErY3BORmxHYXJVQXZBb2lX?=
 =?utf-8?B?RUtOTnE0eUFmQUtqa21KbEM3TmhLK0l2cnpwQkJRV0pXZXhUWlcvUE9tcU02?=
 =?utf-8?B?Rml4c2huR09TTnR2VnMzclFDT3dCSXY5cFRwb3RFRTlEcDkzM0hoNnR0VVBO?=
 =?utf-8?B?UXZrME95cEpNZit5ZkxacHVBY01ZRzBhblNFbXB1dThNbFpmSm5BUWkyUnRm?=
 =?utf-8?B?V1k3b2M5ODVPQ1B1bXBVVDlqTDBMTkY1Q2syc1F1SGowTEJ6RDdoVVZJeXg2?=
 =?utf-8?B?b21VUXBlM25yWXEybFZrTWNIT0RhVlhqamJ0Q2VDK3F6QjBwcldielJDRTND?=
 =?utf-8?B?dU9qWHkyVEpPSkxMTHkzVkNiNUtmYm80UFp3NGZqU3ZCQk9SUk5jU2dITERz?=
 =?utf-8?B?WWJiOEQvZ1daVERMcmNiNzd6a1VoT1pvTWFFazl0SFhLc2FEaUx5R1FZeFVU?=
 =?utf-8?B?VU16NXEyaU9vbzV4Nkl2U2VYZGhVNmo0Q0tsRi9lYTZQOHBpZG9mM005bEZL?=
 =?utf-8?B?dVFLRCtMOU9QWEVvY3RnR2NpTkxKVTBxVHY1cythNVFsc0lyclhtUXpZclF5?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wysJvEu6+ApReWn3XuGpsXoIGPUet/szA7PDENL7v2whlqk84GNz206u+z79RVmzWiLDwz3g/U8LPpYTCbRHKYQL5BXZNDV7KuEUhzxoNF88a1o5nZejWGqPHr5mlWTCmUqqjrfwF+e+sROAnNYIdZOyd+9VpVSJU+yEJzEyqzl72xm9hCaJThT2LLPqvheiX/ztGbZMfoVoR9ofpkKJv1WlZg+GLVsZNXQoXvCuVFuACxZep5jV7sZQQj88MsmMfOdrMcBaluaIbTcJ7kfX5mrU4rHvQ59Sj3M09NM34Xc4VSzuU6ijGHgBXD/2r4iYxp2rTEyPK+bj8uq2nYFWRIsWq6wzmaVFzpYWmZc/Rrj67R5p2sJ8rnPcfep43O8OGovHJYiNowVGcP/PCJrS1AOTTWCRMaPFFsQ9YIDo7G50xZ0xRE8YSNwatUhf7T0Vcnc3z4dV/pPJvfUK8wFiR8iRTDFaR8WTIBrf6Om5Z7w1m1249uR4AY4akt8zIGkZM/dz90gYp8LWSHqeCsKyGdycgR5en2s3DJAIE4zkpPOiE3h3H7cjedL61JqG6R0+XlOr9KN65XCjSQLdGNylBCIcRgE0tvW/IanQjj5FAGs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f326be8-0fb9-4ceb-3643-08ddd5ebfca2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 19:52:48.9716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XqeILEo3LPTZTahWVOAAVgSRMr3zbn6NrwPGBfSpPNYYfdUN9utNxrzYa7RBtT/bx4IZUY1gZJjLGT+HFRDepdds7dDuU2sbEsY67NGzcW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5780
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=771
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508070163
X-Proofpoint-ORIG-GUID: zVIlWHBUDh7ntdT1-0jhpdtjJjZGO3cJ
X-Proofpoint-GUID: zVIlWHBUDh7ntdT1-0jhpdtjJjZGO3cJ
X-Authority-Analysis: v=2.4 cv=QORoRhLL c=1 sm=1 tr=0 ts=68950416 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=OQPoB0lYbZr6UV-1G_4A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13600
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDE2MyBTYWx0ZWRfX6GKDwX3dTmhi
 gNt5ErbPgHDEmCE5M4zejJpYENCzuoXzXThSCoR+q7IAnb6lNueZxG1inuoExJcaWIbwwyvHDch
 hk0aLRgHkFgjomU81D2R4vGKI5TWJHBmZQ3NXMDTn5qXlkL4hgGyWIKgNNVlQr7fsw2KaMthTye
 OaxyMAW67+fNteCxJF5GS84iGgxYBaeQbxfczG3JaMiV2wxxymtXiaj4+SrCbytkQbWBx9vFb7E
 UqTUWMY7c0LHFLka6p6FErCjeVabzX+mM+VWvfXzTw9SeuEwny3PKWZlH83/M3QDrx6mQERkZrH
 4zNrJggD0MCSPpXWcQjWLs3YziACZiB11+mQnn4RwsMwJ2XayzsL0mGOaSbt6wQgI3YrBUDb2dY
 AjQ+8y3fjrKmjL86gO3TwqiXLJjLc+2CkigNaflWuYHl2WfHF6H9lNAlNXpbgjMZorVMkZl9
X-Stat-Signature: x8h6rw9f9bkgp6kda7ewsr6modbwim8h
X-Rspam-User: 
X-Rspamd-Queue-Id: 5120F40002
X-Rspamd-Server: rspam02
X-HE-Tag: 1754596397-508417
X-HE-Meta: U2FsdGVkX1+dMQ/1v222nsISbTX2KyY9Bo4dkhYvjNciGLYF7CrkucBjGzsioKSxAWmNm633vW8HS2HWi2E0ADeBZJJXcHJsosBcUVEsTlwVUyhGzXQNKjuWH5cPoktyNRnekJrV0WFI4VkNCxKeS+8/3QpLgfNYz+8OxM5qKouQncAsqmiyVlKsDUVsczvy/jayt8K/klGvfEPSOSjWb4Bp7wEFPpPKxUwz2RHSmtn6u2HMrTKyIFc8HnkQaDbxmTWXxBwJtXJmVOGYIn83rYmmeBcj1hRnmSmfvuDdyPT3rerb14VUMof1uS7faJXtJxZ5PMtCQbf2iMZ0p1/Es8W3zCeB5keEofnClazGY1HDcVDdx9nGEqtDsefEP6COWZIjoGc0c0eIdHh77seTBE6PYV2aAAsPWmDolMXfBnfiptmj5ztq35K259A9hAHbmTzt3GspCm5c15B8TX3W5J/Bi4Mj8NpCS642eDnWU/qE6HwXAiDefv4+kt/sisArzYZ/5xOOnI2Wj9/C0t7y2j2TM7pQ/Do8Nlr/3jh34MhSQ0znEyvpuE3uvoz2zIUPXcgZcjb6D5NxaY/5mhxyhTMQRE5cgtMId8CveD3WvhlcIlXJhkQVB0We8WOCKZOoMwEyFlK2ASMEetHa6LY5Wa4mi3XwycYXMOSjFI+LmD17pU0bBmnr2j8gcWU20CYXZk/UzG7R7nqvEPZTxdU8depMc889uBjNuJQlk3RBUtgpu8CRzGanJe0DOxb6Wt0MxLPDUJmb0QnktHs+W5TkXwkG7E52CzHMzDBnF/WpQzyHwWVNbNzA+R94KheVqOTnKbJLcFYCim9v5FUjPeeOoizED0FHNA2Bao9PIzXC8s5IW3iCuQo0ImZGMRBQMQ8LYA7e8/dtiHlFS0nXdFIhT6ERsXRWs6ApK75onq+QFB4WOqX3+3k0GyFGAE38wEvdSj9oOpOSXW5Utlophex
 6ZlsCwZ1
 TrrczM3/lNhXPRnXTy8BEMmFfnR8oSdCE9ePT9XBLMIzNfA/gvt08lx7Apau1vW6lwEow8uXmOxLMfGB576veE26GHS1mQRsCXl/IcXulcZ8Upx8qrxpuSyEUP6eOKorEhvTWQh9VzpbrmK6Qo2OVyOLhnlMtgXVJKX6Ghwzrz34ZH6y05J2MeU+th+PYGVbLoAq0IZghWCo+ysFuRoC7dx6Answ43s/NYj3oH99KW8kc9wRzO+nsdDSg+I6GM1UoJSXnRL3iKLXYnFXLiHey/bIeNypGZ6qTN9Fp+8szFg3eMtXhnWjur/RvvbLCJ8hFvmQLpiEvWMXbIJnnEzPW6JBJ5L3zZGpzaNZvHoJ+2X6gSBocJyf9M423u3RXx89lLlKUtbugTfwGGY0E08TBZ6vCo6eh6G0k9kwNtxm8xN3RUiZNMIs6RShMi49DjRLkXT7T8wu4V0gab0T16qoQAjkulwvkO9RMOgIthbNXlLCUFbmI0dCYMu4QocTeSn9t4JjaSMMekTXhngb/TWIMVZyX9LZkFzUbveod6xy5jsT4lGp1rt0ezZflrQVKSjfF9/3mNbr+1OiSiGOwbd3lS0FYGrkkcvuQtU6oqs+f6LJHuyFFjBxDhKYQHRpLiQSAlt5pb1H2JAWovf+5Wy1wkEHwhXq+n7/e+iBawzD+PPg8/QstGaaikN37QoCEIR5EIpaBFE2nrEkHLv/fmDXhB+JU0lCctoV0uX3Vvd5BjIwgZbQI3NvVUKhi+aFhXT9Z+iopyU/p3kLApdwRxCiadoKkJRwlBvRRQAYKHgfzDqJdIFWrwuuJavyttA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 08:31:18PM +0200, David Hildenbrand wrote:
> On 07.08.25 20:07, Jann Horn wrote:
> > On Thu, Aug 7, 2025 at 8:02 PM David Hildenbrand <david@redhat.com> wrote:
> > > Sure, we could use pte_batch_hint(), but I'm curious if x86 would also
> > > benefit with larger folios (e.g., 64K, 128K) with this patch.
> >
> > Where would you expect such a benefit to come from? This function is
> > more or less a memcpy(), except it has to read PTEs with xchg(), write
> > them atomically, and set softdirty flags. For x86, what the associated
> > folios look like and whether the PTEs are contiguous shouldn't matter.
> >
>
> Good point, I was assuming TLB flushing as well, but that doesn't really
> apply here because we are already batching that.

Ah good point, but indeed, while we force a TLB flush if we discover a
present pte, we do so only _after_ we have finished processing entries in
the PTE table, and we would only batch up to, at most, the end of the PTE
table, so we have zero possible delta here on that.

 I did wonder if _somehow_ we'd get some benefit by grouping operations
(yes, this was a handwavey thought).

But Jann's point puts that to bed...

I really feel like this is a super arch-specfic feature that maybe we need
to go around and make arm64-only or predicated on something like the
contpte hint check to be effectively equivalent to.

Because my whole basis for accepting this on other arches is there'd be
little to no impact and now we have seen a huge impact and it's worrying.

>
> --
> Cheers,
>
> David / dhildenb
>

Cheers, Lorenzo

