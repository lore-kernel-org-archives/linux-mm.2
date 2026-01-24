Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29E32D715DB
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 11:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303756B05B3; Sat, 24 Jan 2026 06:40:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DBF16B05B4; Sat, 24 Jan 2026 06:40:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193B46B05B5; Sat, 24 Jan 2026 06:40:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0016A6B05B3
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 06:40:43 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8296C570BC
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 11:40:43 +0000 (UTC)
X-FDA: 84366665166.15.E103A81
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1594E40006
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 11:40:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HBvi6HjJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mAYOfzgG;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769254840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Est7CpZVd/d9y9ZjP4jdhuxlkt8Fmes4uLds5lmlzDo=;
	b=xiawwzeRuiqBMyzkRt4Rwc2GQ8v/gG4sZ6QqlRWdM+2ZMEIk1R1CURk9od52FRLSgyIQH0
	MpaNEBaw5NsvBBif1N644BzgNjCDPtL1GrOGNumcst0DoCaRVeDySP57tcButKhqfd1mkv
	H1ar9RsyxqLHkLbz+sla/R4WGxjrgsY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HBvi6HjJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mAYOfzgG;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769254840; a=rsa-sha256;
	cv=pass;
	b=4h+VZInvFh6Hh1j001/nwGQz91GoV3h2Z0UIHfCHbtgftA5Tm9BB3ZK4gihnvrmDXUgY+1
	5e8tPkAZMy3f1WZJrFtPMXG4twx8G9gkEWHJwy5fXxM8x5i37VWvajApNrY8rPdHkaTCDT
	6eIlp/+S/2VTwcgihWGnD65QJYzdLeg=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60OBAmxv960537;
	Sat, 24 Jan 2026 11:40:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Est7CpZVd/d9y9ZjP4jdhuxlkt8Fmes4uLds5lmlzDo=; b=
	HBvi6HjJlB7I0RlyR6p5XtLGy9S9gjJsa/EDfJkOzO+E54iatFSZNYsrTSRwztir
	DPGuW0WQ/nV/JZBe79g9pqiItdU5VRKBOkJ0SoanO+WRKK82An4vvCQhwfj2ukAm
	uq5HmULcUKbDaIvzNEkMlYBv3k2n6lS8DcFTb2WdYxcSFobaBvvDh+G4Pq9H38lk
	7her8gKJv+cODjR2PoSWLxQA68LXeyD5DehrxZx1uKTWSqDkOBXweXpKfW9e87dj
	jqK7AGFk1colvqd3ieB9dYgVQUQZITARqP4CnyTNrZz3ezeSxfbBURpAXufMfQCc
	9s0W8aJiN6n7cjz0gvtAKQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvny6r5wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 11:40:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O7euWV033453;
	Sat, 24 Jan 2026 11:40:27 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010009.outbound.protection.outlook.com [52.101.46.9])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh6c8ef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 11:40:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PqHMx+baoC5uwFBnMEi/VZyZWVjxmV9MmTtaQSTCJEYc3f/bwFw/ysYSv1hqJpuKIdlpp0GHrTQiCwvvfhvFNf3eG3IbyOiFEpcOTril5x73VMTO4FnKYAY+eGdMTVvpSoFoMusNg3ZUW82xLjPqm2JrwT0U/fyJlndLTru0SsNVrAprxH0I3Bu+2NYj4ce7I8AEwEZljm9NdC66hPL67J0CoQKHhmOa8A6wntPRRH4LDFhhMtgjJzkHL5Kd0thL+n2ase4exqtpRkStzPCcv6RL6BEP2Nrsin4nsv2pv6c5348mR9x+I4RlYADrtWW0bGEiecAJjZarEfgI6z/tKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Est7CpZVd/d9y9ZjP4jdhuxlkt8Fmes4uLds5lmlzDo=;
 b=FjHnTXeaQ0nSD+lj9581OQl6gxDuZI4Lgk/l6wiirsk3m3COY3VEOHggltHCWcvj83+dzZSzWGsPknF4H2alQfbxQZ0rSDYep54fENk91VXj/v5EuI1ylDbYCcH//wxzJNFgHiXGNVUF9AYj+1tRwG7HI5VR/wS09TJVdrTG41xJCiGvpY+DcZFwJl6JBolkQODL4aoiCvhcXjxi4XpgfVoZ+nkM+4jaQw94vsA+1PbGV8wMk2CY7egSMKYlYVYARwt+P5JsyGa+DVB2+x8CAoCZ9bvJWWwmexGqmTR73hLvyyqWbWvPhKWH5uVVJHyorf0RpKGWJaNsEYSfEtwH+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Est7CpZVd/d9y9ZjP4jdhuxlkt8Fmes4uLds5lmlzDo=;
 b=mAYOfzgGjU39k32zxAKUl4XEt5HpaaVn8qlH2e9KJgqlq4RSP7iTfLa4o+23ZDMr/0JHTIUL9MK5SV3CVxg6dGUjlw3iIa+ZATJtdb0GFUHK2uFTCbWRXOT0u3ocCBqQmEuM9aamVGfR19KAyVKSVwYqTBLrOpe3p5HVSus24P4=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB7580.namprd10.prod.outlook.com (2603:10b6:208:490::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Sat, 24 Jan
 2026 11:40:19 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sat, 24 Jan 2026
 11:40:19 +0000
Date: Sat, 24 Jan 2026 11:40:21 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: "Garg, Shivank" <shivankg@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wei Yang <richard.weiyang@gmail.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH V3 5/5] mm/khugepaged: make khugepaged_collapse_control
 static
Message-ID: <7ac06a41-73c8-4089-873e-7bb4cc1b3e02@lucifer.local>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-14-shivankg@amd.com>
 <6486c6dd-2702-4a4d-9662-09639532ce6f@arm.com>
 <afc56f8f-0c22-4bac-a99b-b46df346334d@arm.com>
 <ba4502f7-0c35-460e-a42c-d32dea9ab9eb@amd.com>
 <50da84da-1cd6-4b8b-babd-b6dea405713b@lucifer.local>
 <94c84a3c-8ed9-4bb5-8e64-69bcb8306aba@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94c84a3c-8ed9-4bb5-8e64-69bcb8306aba@arm.com>
X-ClientProxiedBy: LO4P123CA0167.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::10) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB7580:EE_
X-MS-Office365-Filtering-Correlation-Id: 39ccc4b6-9467-4094-c3a7-08de5b3d59f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MklSdk9DSTIwSnVBQ1F0RzRUSUdRdTZiazNxM0Vwd1IydlJ6Z2FudFNvM0li?=
 =?utf-8?B?R3doWkZnNWZpeXVSWHpqWmpnNnRNd3BqanZPU0tKUHhVRUUyWnFrY2kzdnEx?=
 =?utf-8?B?TnpsVGdSak9CTndvakwvT1ZPZ3RwdFVyeSsxTm9PNVNXVE1tSlhJTHFWSTJo?=
 =?utf-8?B?dHZDejRyRUs1Z0dKUWdySmNnSDlVNVVkc3V3L0laUEtCOU9kZlhZNUg3NXg3?=
 =?utf-8?B?Ynh6TUpiZEFZcU9lM3FiZ1BiR3dTTWJua3Z4dk5udktxR1VCeUdBaFRoZlA5?=
 =?utf-8?B?NFZTNnhjQ1NSdTdmTjY3ak9xb0NZWHhwVkZXck1sU0NRQ2lvRnl5SktSaWIw?=
 =?utf-8?B?NzhrWVNrNVhybzV2WDNlTVdMdmdGcXJFa2tiejFaL2Fkd2xFMnV4Q0pGajJo?=
 =?utf-8?B?OFRXa2RNU2crQkNzUlJ2VndLcEQ0VmNZRnFYcUhFK2xQQW1tZkFDalNtTkxB?=
 =?utf-8?B?TmZzQjZ6ZW1Vd2dVVUNKSUZpR21hcklweU1FOFNUeW9mQVZpQVN0Nk56TlJB?=
 =?utf-8?B?c3Y2a0lLS1NTZ0d2c3hsR1BPZVliNjRjQkg2enk4K24vek9TNTlmbUl4c0VS?=
 =?utf-8?B?YWppdE5Tc2JJdHl4b2RoekRUQm5TV3hVZ09iQ1hwZktTZFJJM0piSUJLSkRJ?=
 =?utf-8?B?OEZvTFdsRFY3OXZNejFiNFZDd1lFQjU3bUdMWEtLZzVyeU56SXB0dElKNTZn?=
 =?utf-8?B?alFiTWc1cVhrTUhtTU5CRUlRWG5YYnRDR2pKZ2s5RFpqQUFsWWJtblZpVytD?=
 =?utf-8?B?VGNxVC9Meis1N2dYU3JaWEdTeEcvRzFSc3J4OGVQVTh2cHpsOUVBcjhNb2Zq?=
 =?utf-8?B?QzlBekNCcEU3WkV5TDQrd3hvdjhRK1BqNjA2QUVvMS9ySHl5MHhueHU3UXhq?=
 =?utf-8?B?b1lKMW1DSkI0YXhkY05JV3VXMkZ1eGdSUWxxUC9HUmkyVXdxcitYTDBzaVBv?=
 =?utf-8?B?cEpWcUx2SS9tVlNsamY3MW8xRzNDTWd5b3BIdlVaR1RPVHN3UGtJYmhjYzZS?=
 =?utf-8?B?SW96U09yaFRnanpTU3dmY1J2bk5mdGFQM29Na2Y5ZlZkaEdmUEFqL3FtVzJL?=
 =?utf-8?B?MEttR3lFRXU1SFBIRXhyNURnTWRUaE5lZXJsbUNjY1NaWXVjZ1YrdkVxMlFO?=
 =?utf-8?B?YXg1d2tZbVZ1OUc5Q2dzNGNUR3Q4TlZmVnlaQUVqeGZXMUV5VGwxU2U0anFo?=
 =?utf-8?B?NFdSdithWW5VcS8wQ3NVZ1RzZVdQUW9BTkNXaHNuMkZwd1kzV2xxR0NrTmtQ?=
 =?utf-8?B?Z0ZDTGtmRG8yUHV1UFNTRlBtekQ4MUlXK3VSNnRIRmtBOHZPdldRWVFRT2JL?=
 =?utf-8?B?cXd4SzhSUVNSdm1PWnRMdkYxbVY1SlV6VUxlcXBmNjNLSG1Rd2NpLzdCanpK?=
 =?utf-8?B?QjljSVozeHRhVmw1bGtvcmpWVFA3c2pHS0tVckJ6OVFhRU03bmQ5alVVWkls?=
 =?utf-8?B?QVVJRmozQUFFWlpXVUlOdXk2Q016NzZSWWw0K1I5V1dWbVVqQ0Z3QU85ZzB4?=
 =?utf-8?B?TVdWYXB1SXZoTDZGcnpRdmczSmlMU2s1M2V0Q3lDQTgzQmp2ZVdQOFBlelI3?=
 =?utf-8?B?Szkwc2p5aEJUWnp2N1IraUZOY0tpcXJLMmhrS0UySGl6Vmw2b1NJam84MElt?=
 =?utf-8?B?N3FHVnpMWC9aZGJWYjZ0djRNN3R1ZHBEUncrbVlEelZqcWw1R2NBenpJTlYy?=
 =?utf-8?B?dVZNMWFUQXBxMkVDQVM4MkZGZHo0U3FkUkJQOS9HYkVmZWpEMHNtVTRoTG5z?=
 =?utf-8?B?akZrb1VMYnIybEx5QkRVT2hPMXVKdXc0Q2dlMU05T2FLM1dJKzBIckpLbkFr?=
 =?utf-8?B?MVVpS1M5VWl6cDFGWXRHRG5JODM2VDVucVdTK2ZyQjZmaUVZdGVtQ3U1Z3Q3?=
 =?utf-8?B?RXMrdWhOUW4xWDQyNkVKWEtvR05LUmtpbFJzMzR0Q2JkMURWRDNTZi96ak0x?=
 =?utf-8?B?bFBNSzlVL1FDQm4zNEdzMHhKb1ZpZ05RaG9tVUNCUGswUDlmdHhVMFoyenFz?=
 =?utf-8?B?TkFCd04wM1ZFajBDbDYxWVZBMG11a2E0K2VEbVlBVm1nbWFVVTBsQ1ZCMUlS?=
 =?utf-8?B?QXlOWFBUV1E5OTF5RmMxQlVMWnpPV3hRWGVYOE9tMk1iWnpNSjU1VVlpTXpw?=
 =?utf-8?Q?vM7A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHh2dG41djhjK1RBSmtaVnZSMWJCd0UrMmdTQ3F1Z1pHWEdIaG5ZZW93Ukdt?=
 =?utf-8?B?TTRXbW5jbXZBLzdOZ3NkSlBmSFJESkRyMDFyMUxseVRIUjhMYTFrZWY1T0Nm?=
 =?utf-8?B?VnlOY3VYQ2x5Yk9BeTRseTFCRlNtNVZteWNxOWc4aG9CazRuZm1qUy9yOEh3?=
 =?utf-8?B?WFNCWkpIcnhZdGFnbTF1cG5QaHM0UWp0MUhMYU1vakFqL3BoNnkzNWVCYnVo?=
 =?utf-8?B?bUoxWmJlLzF1T1paTFlsMDRHVE4zRHBraWcyMmpPMHB0Z1JWK1NnL1FpTDVs?=
 =?utf-8?B?ek4zT0NZYktPL2NObTF5YWVBenNoSld1c3JLMHR4NHlWcWlNanp3bjVURkhi?=
 =?utf-8?B?anZkVDJCNThaNzBqckQ0Y0M3KzJBMlJxWmFvU05aODV6RmhCOUFCK1ZFclhw?=
 =?utf-8?B?em04MVdlOU1ZZHNVUXdqZmVwL3kweTBsV2dORnU4WFFLTkdITmZoTThMV2th?=
 =?utf-8?B?bVk5V1R2L09pMXR4RDNhL21JNlhnNnFjTSs4cW4zTGF6Qm5xNkg2WFZCNHha?=
 =?utf-8?B?RVg4SXgzYVJhRFhPUGVBQ2xwekhUMkJZalloSlZvZHhxRDBiNVB6K2ZjaDYw?=
 =?utf-8?B?R28zcU55aDVibUt2Q25SQU9GWWcwZVQ2QzMxSVRMek8wQTJFbzU5VnVUS0gx?=
 =?utf-8?B?RERIL2k3N25qSjRlV0RJdEU5dG8rR01PWTFCOFpvYk8vTkVXQjVwbWpVOHph?=
 =?utf-8?B?TTJTQUlWSXVvWXN5UHhya0RYb1NLRHdoS2JHcHc2MlpUOThIcUwyTU91dllx?=
 =?utf-8?B?aWZnSEM0RnljVmU5eEE2cGlybEtWK0RrdUtESGEyZkdJZUhTZ1NMaDJMT1dP?=
 =?utf-8?B?SFQvTnY0RndZblBRK2U3Vzg2RXJjSVhLWVAxWVp2NTRHZmU5ZUNseEYwQTdB?=
 =?utf-8?B?L0FRZTBOeEVRU1RxeWFYblZPNHI3SjdsV0RZNEVXNXdPR2E4K0pZb1N6Wlhr?=
 =?utf-8?B?dlBQdDViRlVyZXFoc1YyN1ZrWU5VVkpPY2cwd2l5OThydHdEeDl2Mjgwc0lJ?=
 =?utf-8?B?MlFrTE5JZ0NKWCtEc1dPT0JxU3RkOGQ1U1ZYbUo2NGUvTVQ1NlhUQ2NTa2tX?=
 =?utf-8?B?ZXpoSnVWazA3bWgvdzBydmo3RkpCRjRNbGxJYjFpRS9xR3ZpMEJycXQzOEcv?=
 =?utf-8?B?cm1WU2treUV4OU15MFZLcHFNamhNN2taK0JxYitNc0lqSnE2Q0dYTXlaVm1j?=
 =?utf-8?B?YlRPc0VHV2tWREF6VkZLK1BDR3h2L1pPbC9MUjBadVJVbjR3R1Zpd2FSRUt2?=
 =?utf-8?B?Wlp0cWptYnZoRi9LcVlyYmVMYWRENXNqOTYxa2NDWjNiWkx1K0ZScFJVdTlo?=
 =?utf-8?B?aEw1Uy9YbWY3eHB0RzR5TWoxYXVFcUNXSUNYRFAycjYvd3ZTTlQ2cUgzMVNr?=
 =?utf-8?B?OVVTRThXMXlwWnpQRG91MmNxQ2daSElSYVZ0UWxhNWsvenR4OFVxN0FzUmpN?=
 =?utf-8?B?L05WTjlrVHNJbXRmM24yc1hIWjhRdHJTZVRHYXluc1B3UW5mQXdqREovYkVj?=
 =?utf-8?B?WmphVlEzdVlzbE1uUkFJMGFVMkIyYkdaS3NWWERmdmh1VVRiWjdFV3p2SzVa?=
 =?utf-8?B?OE84NEhaTmhZSEdnUUFnblZnaEFkWnlWTHN4RzRyMUttMWNWWk5nMnNMMTBj?=
 =?utf-8?B?bjQxZ0J6YVlrWTlaWnVreHhxRVFOakd4M1lUZDd2cUlpK25LM3pzRkJWTC9G?=
 =?utf-8?B?Z2lrYWhnZmtFRDZBRGRvZm5sVitmY2dpaTBPT1lwT0tDYlhQYXc5cFdYaWNm?=
 =?utf-8?B?WGV2V2lXTFRudFNBcXh2TWQ4Mld6M0xyUTIzT0h3azVjK1lPV2ZiZTFaQTUr?=
 =?utf-8?B?UXlWS0tMY2RvUS8weUNUQjQvZGFLbEltR2drdGdQdDZ1STJZL0VkZGpNM0E4?=
 =?utf-8?B?SGJnRkYzRkRReG5XMzBoZDZrWUV5MDBhcjRnZHFGa2FVS2ZsTy9ZNFhPOU04?=
 =?utf-8?B?R0l1VUc1ZVdMZHZaZ1M1SStDendMbE9MaWhNZjBrK3dSMi91TVFKYklhMCtv?=
 =?utf-8?B?K2ZvZW0wZ2NFTHpxQ1NvekJkd3Jhbi9NWXNQSUFaVFpBMjVsQzR6YWxwTDZE?=
 =?utf-8?B?SDViaEY0TUhoUUdqL2NiWUpVTnRrb1lnOG9aV01qREtETkMxTEhZYThBMTE3?=
 =?utf-8?B?bUtnZFJEM2UwaHMyKzlVeUtNbjlWdGltQlFPMHVJc2VOd2RLS1JBc0JINzVC?=
 =?utf-8?B?WmdkbUlJRnJQT1lWbzhwRWRHUjdFM3N6MnhrZFo2d1dPcWFFTE1WUkowamoz?=
 =?utf-8?B?RzJoZEpONTJMYlROL0cvMnk4cVk3cnQ0ck9Zc1VJK2hiWUpEM3JsbFlCYVNU?=
 =?utf-8?B?aHZ4K3MxdEE4bCtOb3pIU1JXT3IwcHdJalZPU0ZpU2gzOTB4VUNod1M0NDVZ?=
 =?utf-8?Q?bSm4yRXGg7WQIrM4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j14ErSUwlUph1xaNdMJLrrHvjMHocxt52mKsXkMNTlWElAHcceYGkvqbedJSsAUhLjBv/pIIZpCSTDtBTD//kGam94ZQ2j9nYSQCF9PMPwvZc2JySB9tuDMaNXgdCF8Vmkfai7DiUf2ry7DUSQPvW9OIVjrY93FBSkyKnQzgwKIyPIkdqp6FDYGT5beG2BTG0nwRJTHadTWjRqEMhfOZNF3YkplNUon3kSpe2AGm8ReXOKanZBBmRG5iMj6yQE5/HF1sW1ufkhI/mrVJlMjHqU0pvGouaHdtzxvETtZZNLIYqRiuCBOmoNW7DXQdH1rOFUCkPxWPlJXxDhzVmwwXVegRG5/RgTjn5slpPXLPbj7vuGxB1TF4yQLnmjMxIhVW2Tsl42bWa6O+FPpwcDMIHBhx6B6rCKzRR/RkFisGrVlGeRaiANMVPMlnBS841xUMcRC5owR4/+uPf8NQ///fs03cqln6gv8zm6N6ah8KtAVGaBKEqXYU/TMHn47N5yzVcq8OgLHh9GfJB9D3rUx+BpXrcG6S7+hg2cPrVftCHcikhuzqa2CQtPPJqwSHm540rJvVPJnIuv4mRAyHoBEn5NdT3kp/QVUdpice8WWXuFY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39ccc4b6-9467-4094-c3a7-08de5b3d59f4
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 11:40:19.4343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7Lj6WaVVzHFXeiQvC3n2uQBS/y6PbUhMgGBdi6mpUcuESqrV0fRDcZ25OAwaALNLDyzFhd6+1KG43t93UN+/4AP3mwBwj0VoQOcwpHluXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDA5MyBTYWx0ZWRfX6JEGSC1k2V7q
 O6z92cZGEbMCrCyLJu7+ribUJnag/h8NOgLVVUXwcxFDQCSn9s+C7xKlyqFVO5l1PKweCxSvEkt
 6dNZgebyWgw+fRALHCjjIPnujZ6KH/gOU1TRvp0l0HZ7DdgpjwyBoGfajFKj9FQRakH6i76N1ha
 IGZ30DCXdMkYES/afEwwqHCh/Q7pdfQgkQBD7unS4SUB86aGPBcr3sLfOMfw30AcuOt/1tx3bLm
 T+KX2MLqkbwD+cwE+Q6UdIUNrJQuRB4QdydThQ3BBF4l3InKiZr3MhdRBBXrXojxwkSkcgX0gqF
 1DESNB1MZ/AUIdVck6Ezw6dSF/Xr4mBqjvaif6TMt0lgFPG3Ot7xDk+4EEhIMCnBnCmKK43k1L8
 tpI2jGLjVBwCHtpELY5uCkmZpYtEp7o73m5U18aItPZ1o7g2CfZfCuoirtFymjXIh4+FTGAme0R
 jeaeKIhu2+uCZtpJ0dg==
X-Authority-Analysis: v=2.4 cv=C+XkCAP+ c=1 sm=1 tr=0 ts=6974afac b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8
 a=zd2uoN0lAAAA:8 a=K2x07VIehQ4J9c4nT1MA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: WzBvygOcEAarb0rVUigzVPR7iUK6PLXA
X-Proofpoint-ORIG-GUID: WzBvygOcEAarb0rVUigzVPR7iUK6PLXA
X-Rspam-User: 
X-Rspamd-Queue-Id: 1594E40006
X-Rspamd-Server: rspam07
X-Stat-Signature: bkhraxmu7zmuhamfmqf6ibk7hcyppkig
X-HE-Tag: 1769254839-34741
X-HE-Meta: U2FsdGVkX19DF/k662arRyFWiCzZ1zzhODtwe1acSiOtqjs2axzL3mg/AIXl5Ey2sKEJx8UzxFGMw8U6hX8CWVks9ly2rLgeyUe/VWxd4v7nxu2hACHnmBeI4qxMqX0dpltT9jKNHHVvIjum+BFoufQygOKEjWqgLsXsz/GNjBqQCTSnzX9raLJ+O1aO/QENP6xxi8j9Y4mQepOSjvoEigrj4GzO2vcjakaQPgGv2yKfH/4jlEErJkCNWEOTYW0ivxpKyq3NuCzp3WavQxyT/Fq3kaZBUvEjPooPmIbCyXrE2o5lFhy9hocDlx+UC1wbuYYUKqcfFGoLBA4uxjPz4YB3rA28ApnsAWBfBwcb4+G6G2GY1qpf/gpgDIVDjhl+YWvnVv5Ny0wf2xJixkWVtsl7+6KJcJMF1NT5iL8NNMBgCz9I1BCZI/TZiiI9qkl4Nd2H1HQe4d7PS7LIYGl8G3HZz3vk3KlzvumQgJRNXY91Fi7aaIKIPQMXv8t2A6zvl8Joh64Y6ptldHtyQGKBjlouN68z4gdRiRZzxqS4R9Xw+5RvXL0DxefnV+Dtop+0yW6fLbGbG7AnznnwB6+IAEOdQb4a+BOQPnoTdpCtRlv0uCGlD+cNawFKeCD7Qwp6zRNdCRtETbi31ZqyNOzlYRbBSp0wy+mzpfTe3l6sUiWkVIlvJWVyucAliomRgIahtpy5+4b5dNhFBx4tLSxoYK96RuQEQXX1ptvn1GYdlBR7JeSTcyedp6pyPKuA2jQwApONoYscPXhXyDjNE2zLDdhzbpacDzwM4Ds2gTqMUeGfAWh9mWQ4wzGRyvw2b7ras7bvTwHZS/ixdKPvV/lc695og/YZdI2YBEr6287JjXC+bTsJ94SItcwY/m3ikXgg5wzRN4XCbY0OJPHnwHkuVYHsxsqP6Yl81lmD0+lCwCEVlncpE9AMBVf8TEChFOLaxC/OppovJzKoey3VOlo
 ktWOJdcX
 7hnr/D3l2UtaL1n8qtQR93gyFJb0cnBVPGKdUZaeQ/yDD86qkepA4t5zG/0H7+xrIP5xZjAQudYSJ0Oh7fkZo4HOvvPq5mugTox5feqLqSR4pZ01lTSVypNohdWg7JbYWnCHqG0FXJfFn8wKtmyCYo3pTZzO7WlCXEAQIB0UdELODqBXWL3Y//UYGn9PEqtUkuQhbPMe8+/7CopP42YtTIvHalUNQppEMcb+jHApv5LClJTzsX/mWK+3XjMeuYU6TbYqPJWeEnnS7tmrYJy8A87mE8MfkdwDRjmUYQxqJuaeK2erYuFENnitaEArvNP4mXTHsakpl9fHNFvuHdiaVnXLwCS8HafJnql5bTmohBn0zOP17We/P6mkCkj2n9q104ITz8rqNi75d1TSVqNg5mpUFQqdik5AsePm1C2caUy8TqdlqPnEqqy0p2DOOUbzbF+lX/Qlj8QYvsLnrUlU8LeOBy0bWVrJa8TburpONdB2Kgq+i4YdPa7EOsrBj6wV2YMPv94dEm0FAF7xdzTTXC13PREEMCMpJco+72lCrJu9Ua15vfY7iOebkxg6cMInvkPiw5Z68PnGgvlkj6GDNIcyq6h1y+czAwAkcOlNN3ZgvO9cSp+wl8mympscI+hEnksnJMP1q/LsIXmFXyIypqLUc/H4Z+EevbbeDH6Vzb7bD4pgt3UJr/rH4IZkKYuAI3CxWRbeMiJ2dUj5+9zLLoimZpJttKkz3cDa+p1bIBlkhzt58MK4m4RW/pBmfR2OLq8eAwZEpQokG3dLi8WhIbCr26zuNcfITah5roSqXLpKdpiPw1IvLUNF6FiLJavbK532kz/7ZLGb2RlmCQxxdKD0fSTftSz8lrl5HLR2gtMIHThOkTlc0eAQ9mDvW00dytiOGlh7DT9G9DW90wDp7UO1i2UOA7miI2Y+n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 04:24:24PM +0530, Dev Jain wrote:
>
> On 24/01/26 2:31 pm, Lorenzo Stoakes wrote:
> > NAK to this change....
> >
> > On Fri, Jan 23, 2026 at 03:03:58PM +0530, Garg, Shivank wrote:
> >>
> >> On 1/23/2026 1:18 PM, Dev Jain wrote:
> >>> On 22/01/26 2:58 pm, Dev Jain wrote:
> >>>> On 19/01/26 12:53 am, Shivank Garg wrote:
> >>>>> The global variable 'khugepaged_collapse_control' is not used outside of
> >>>>> mm/khugepaged.c. Make it static to limit its scope.
> >>>>>
> >>>>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> >>>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
> >>>>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> >>>>> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> >>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
> >>>>> ---
> >>>>>  mm/khugepaged.c | 2 +-
> >>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>>>> index 1667abae6d8d..fba6aea5bea6 100644
> >>>>> --- a/mm/khugepaged.c
> >>>>> +++ b/mm/khugepaged.c
> >>>>> @@ -827,7 +827,7 @@ static void khugepaged_alloc_sleep(void)
> >>>>>  	remove_wait_queue(&khugepaged_wait, &wait);
> >>>>>  }
> >>>>>
> >>>>> -struct collapse_control khugepaged_collapse_control = {
> >>>>> +static struct collapse_control khugepaged_collapse_control = {
> >>>>>  	.is_khugepaged = true,
> >>>>>  };
> >>>>>
> >>>> Will it not be better to just remove this variable? In madvise_collapse,
> >>>> we defined cc as a local variable and set .is_khugepaged = false. The
> >>>> same can be done in int khugepaged() - define a local variable and set
> >>>> .is_khugepaged = true.
> >>> Since this patch has been stabilized already by 4 R-bs, it may be a headache
> >>> to now remove this, we can do my suggestion later.
> >>>
> >>> Reviewed-by: Dev Jain <dev.jain@arm.com>
> >>>
> >>>>
> >> Thank you Dev for the feedback and review.
> >>
> >> I've attached the patch implementing your suggestion and sending this as a separate
> >> follow-up to avoid disrupting the current series.
> >>
> >> I’m happy to queue it for next cycle or if it’s acceptable now, please take it.
> >>
> >> Thanks for the suggestion!
> >>
> >> Regards,
> >> Shivank
> >>
> >> ---
> >> From: Shivank Garg <shivankg@amd.com>
> >> Date: Thu, 22 Jan 2026 12:36:28 +0000
> >> Subject: [PATCH] mm/khugepaged: convert khugepaged_collapse_control to local
> >>  variable in khugepaged()
> >>
> >> Make khugepaged_collapse_control a local variable in khugepaged() instead
> >> of static global, consistent with how madvise_collapse() handles its
> >> collapse_control. Static storage is unnecessary here as node_load and
> >> alloc_nmask are reset per-VMA during scanning.
> >>
> >> No functional change.
> >>
> >> Suggested-by: Dev Jain <dev.jain@arm.com>
> >> Signed-off-by: Shivank Garg <shivankg@amd.com>
> >> ---
> >>  mm/khugepaged.c | 9 ++++-----
> >>  1 file changed, 4 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> index 9f790ec34400..c18d2ce639b1 100644
> >> --- a/mm/khugepaged.c
> >> +++ b/mm/khugepaged.c
> >> @@ -829,10 +829,6 @@ static void khugepaged_alloc_sleep(void)
> >>  	remove_wait_queue(&khugepaged_wait, &wait);
> >>  }
> >>
> >> -static struct collapse_control khugepaged_collapse_control = {
> >> -	.is_khugepaged = true,
> >> -};
> >> -
> >>  static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
> >>  {
> >>  	int i;
> >> @@ -2629,13 +2625,16 @@ static void khugepaged_wait_work(void)
> >>
> >>  static int khugepaged(void *none)
> >>  {
> >> +	struct collapse_control cc = {
> >> +		.is_khugepaged = true,
> >> +	};
> >>  	struct mm_slot *slot;
> >>
> >>  	set_freezable();
> >>  	set_user_nice(current, MAX_NICE);
> >>
> >>  	while (!kthread_should_stop()) {
> >> -		khugepaged_do_scan(&khugepaged_collapse_control);
> >> +		khugepaged_do_scan(&cc);
> >>  		khugepaged_wait_work();
> >>  	}
> >>
> >> --
> >> 2.43.0
> >>
> >>
> >>
> >>
> > Andrew's already commented but this is terribly mistaken.
> >
> > The argument against it (why did nobody check...) is that this struct is HUGE
> > and there's really no benefit to doing this.
> >
> > Nico's series makes this struct even bigger (...!)
> >
> > Dev - PLEASE use pahole or sizeof(...) or something before suggesting moving
> > things like this on to the stack, in future e.g.:
> >
> > $ pahole collapse_control
> > struct collapse_control {
> > 	bool                       is_khugepaged;        /*     0     1 */
> >
> > 	/* XXX 3 bytes hole, try to pack */
> >
> > 	u32                        node_load[1024];      /*     4  4096 */
> >
> > 	/* XXX 4 bytes hole, try to pack */
> >
> > 	/* --- cacheline 64 boundary (4096 bytes) was 8 bytes ago --- */
> > 	nodemask_t                 alloc_nmask;          /*  4104   128 */
> >
> > 	/* size: 4232, cachelines: 67, members: 3 */
> > 	/* sum members: 4225, holes: 2, sum holes: 7 */
> > 	/* last cacheline: 8 bytes */
> > };
> >
> > Making this static was fine. Leave it as-is.
>
> I wasn't suggesting that! When I said
>
> "In madvise_collapse, we defined cc as a local variable and set .is_khugepaged = false. The
> same can be done in int khugepaged() - define a local variable and set .is_khugepaged = true."

Yeah I would suggest more precision in your language in future :) 'as a local
variable' and set . not -> is_khugepaged true... I can see why Shivank
interpreted it at as a stack variable.

>
> madvise_collapse does kmalloc() to allocate this large struct. I was suggesting to do the
> same for khugepaged, to enforce consistency.

As I said in reply to Andrew, NAK to the kmalloc idea too.

This consistency argument is nonsense, madvise_collapse() does that because
_there can be multiple instances_ of the cc around for different processes, you
literally _have_ to kmalloc there.

For khugepaged this isn't the case. We're good as we are.

Thanks, Lorenzo

