Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0BB9CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 19:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F23E8E00C8; Mon,  3 Nov 2025 14:29:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3528E0060; Mon,  3 Nov 2025 14:29:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAA28E00C8; Mon,  3 Nov 2025 14:29:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E09EB8E0060
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:29:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C5411A02F2
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:29:46 +0000 (UTC)
X-FDA: 84070285572.26.E30739F
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011046.outbound.protection.outlook.com [40.93.194.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2BD01140010
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:29:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ti.com header.s=selector1 header.b=TPZwdYyz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of b-padhi@ti.com designates 40.93.194.46 as permitted sender) smtp.mailfrom=b-padhi@ti.com;
	dmarc=pass (policy=quarantine) header.from=ti.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762198183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmyUgxQau+x30yzApsUA1NKfTkU7mW1NqNGrFuWynos=;
	b=b7hKldz7BcctE/U5fSfZv1sklOG1sw1Vbu9y6xJenTq/2Ao9Ofbotf1PI+uqzZ1He1f7mB
	o2r7s+b4LxAC8T/Lxkphz+C7T4iFAQNqlotfo6YMstK+jJj6fXcKT7GPg5F6e972fGTTry
	E389diweYTliCo0h5jAJ7fKqISV6J7E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762198183; a=rsa-sha256;
	cv=pass;
	b=Xrwr4hH1SWGAE7usZjiJUBrALMS+lbfeqqWO/GwQacqJGpD3Nozi/a0a2iA9YOouJ0fXeB
	RtXIy9hJT5GuF63pJCMwHnWD646C4XbffWe185W7E5w6mFZ9tG8tf/1jBQjU0RZsbRiG1V
	iXdW7uHDmK//q64Ktrg19371z9clxmo=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=ti.com header.s=selector1 header.b=TPZwdYyz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of b-padhi@ti.com designates 40.93.194.46 as permitted sender) smtp.mailfrom=b-padhi@ti.com;
	dmarc=pass (policy=quarantine) header.from=ti.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=neuD4c6/FaUZ+flARujOft2F/m474k85zcuqTkNIm612jYVTVHaN2TZDTWsrElTdnserM3K/ETZh/G+r0XNJaLbnwYfXq5Kc2X2t9b7b8IGMw5pHQLYuMn7T2FR/gPd7GMYsrjCyjvN6Ukd4j2Tr3vFU4i1QRP9o/9yF/6pavaSEsJ7OvTnpSOk6QgtJOmuxtv2pW3/4p05qwGDC8hycsWeDn8hlQgJECrhk6wbPOt39A0mU26IpdjB1WseqIiyXYetIv/X/OPsLUX/3fU8DnIAIp5QciJUCqUn5O+bc8OrQLsmAGVCY5AdoxpJv3FwJnjjBbanDJrgljWDUtIyKHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UmyUgxQau+x30yzApsUA1NKfTkU7mW1NqNGrFuWynos=;
 b=hTFmTs1od3oa3g00c0tYJyid+e4RMS5gm/k2hXN22teCbIofErzfLfUb8+NDAsqEi/HzX5v01qU7bZkJ4X4zi8vbwP+UuoxWkKsI2tEjBumPp5sdr+ARnpAwcfBbJ7lTWnRoUdjokV+8RjkWMQpbVf1+zP7e2U6xzUyDBlQzjp4ZjCtpsEiW+/zpv0kk0/jR1wfUafRHtwXJKVfW5gxqroRLD+DaXBIcnC/HYXBHurhjpQPHtw8fFqD7PYj2jZ0ATrkF4qPAZhGYOIQTZieWR8II0/ehZf7HHDSzJwh+FAvhsPxACaErVif5QHnqL/mz0wmNXKleUwUwUpWeo23/Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=arm.com smtp.mailfrom=ti.com; dmarc=pass
 (p=quarantine sp=none pct=100) action=none header.from=ti.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmyUgxQau+x30yzApsUA1NKfTkU7mW1NqNGrFuWynos=;
 b=TPZwdYyzNZWMS7zzeP56NmZHhHurNce8aoJZFMixbB5ziV/GNSgZ0MT7Js2uvzo1D4aHy7S2JpxUotAAxnTXML8Nrrbdn/PE2ALryy0wJl+co3d2dnjwot/6VaEAagF+sfW9X43Z6wKGp7sbeLQRQ/arXjkomPKSthjSOHQxJTM=
Received: from CH5PR03CA0020.namprd03.prod.outlook.com (2603:10b6:610:1f1::10)
 by DM4PR10MB6181.namprd10.prod.outlook.com (2603:10b6:8:88::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 19:29:40 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:610:1f1:cafe::f5) by CH5PR03CA0020.outlook.office365.com
 (2603:10b6:610:1f1::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.16 via Frontend Transport; Mon,
 3 Nov 2025 19:29:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.6 via Frontend Transport; Mon, 3 Nov 2025 19:29:39 +0000
Received: from DLEE113.ent.ti.com (157.170.170.24) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.2.2562.20; Mon, 3 Nov
 2025 13:29:37 -0600
Received: from DLEE203.ent.ti.com (157.170.170.78) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Mon, 3
 Nov 2025 13:29:37 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 3 Nov 2025 13:29:37 -0600
Received: from [10.249.139.51] ([10.249.139.51])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5A3JTYSY676006;
	Mon, 3 Nov 2025 13:29:35 -0600
Message-ID: <a281af74-99cf-49e2-99c5-290bdb84ebd0@ti.com>
Date: Tue, 4 Nov 2025 00:59:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: Initialise the tags of the huge zero
 folio
To: Catalin Marinas <catalin.marinas@arm.com>, "David Hildenbrand (Red Hat)"
	<david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: Mark Brown <broonie@kernel.org>, <linux-mm@kvack.org>,
	<linux-arm-kernel@lists.infradead.org>, Will Deacon <will@kernel.org>,
	<Aishwarya.TCV@arm.com>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <aQiu-hU3x5V5drHF@finisterre.sirena.org.uk> <aQi8dA_QpXM8XqrE@arm.com>
 <79a1f2dd-6752-426c-84c1-a38d300eb78c@kernel.org> <aQjRa-Bh8J8Smgur@arm.com>
Content-Language: en-US
From: Beleswar Prasad Padhi <b-padhi@ti.com>
In-Reply-To: <aQjRa-Bh8J8Smgur@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|DM4PR10MB6181:EE_
X-MS-Office365-Filtering-Correlation-Id: 62b6151e-048d-4fbf-2845-08de1b0f5522
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|34020700016|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1RmaWU3QittNzVpaWdkRG90NDZWN2xzcjczaktsR3pRZXRoeVkvSHJBQy9F?=
 =?utf-8?B?alZaamxvWFQwWlNTQVQ3MC83Z1g4c1MxMEl3MCtIRXRFeUt6WkJZamNERm05?=
 =?utf-8?B?enVGckROMXMwM1p5THN2RDV4K2FIdjJKcFgvdGVnengycjlXdW5WZUpNNW9i?=
 =?utf-8?B?S1RkZ2tRTU5JQmpHRGtqMEVnYk1HUXR4aWJzekVna1RvYURxWW5qR1JRS25m?=
 =?utf-8?B?ZFl0MS9EMEdsdUFsQWUyeVZicjBQVUVlSFlmeUg4OHF4UzJIR3djblh0bXFj?=
 =?utf-8?B?WDVGVTlZUmIyZDNXa0NmWXNLZERVakU3OWpwTEsrZTN0TVhZWDVZRFovRGZI?=
 =?utf-8?B?Zi91SmY3VlhRNVY3d1VNN3QyVngwRHJVNXpsT0w3VzBHSUJEN3dSTXFEYTJO?=
 =?utf-8?B?UmhsVFBNa1Y2TXorTXJFL2tSL0FIcHhtN3ZtdEdFY0M1eG1SVm5USERTcm5t?=
 =?utf-8?B?NUNvUzFoZmh3bStFUk1nckxIQm44UHZ4Sy81cFFpRy9uTlkyUDBnTzlidWpu?=
 =?utf-8?B?TXNKc0hoQzRuZDlHYnJ0UnF3d3BRMHdMMHJ5Uk1UZGQyQUJnMFJvRFhKU1pW?=
 =?utf-8?B?aDNvYWlKTFc0Z3lLZDR2YmZ5VVEyOWRLZDl1dG9HTGdMbTNORUhKR3dua2o1?=
 =?utf-8?B?QUpldElzWmpJYms0Qlk3Z2lvUjd0NjFYTFAvZ0FZWE1oRi9ucW1QVzRRdmZ4?=
 =?utf-8?B?RHowaXRjYXFxaDZDTTNyUUR0YzFUWm1KLytjM01MNWovWUp0Y1VPVUdFV3Iy?=
 =?utf-8?B?cHdoZWx2RGpKNDZqTW9QWEZyMk5nTzdFTCtBTW9HYjNjNmVkSGo0VWd0Rm9j?=
 =?utf-8?B?Wjh0QzJJVjMya05mamRsd0Q2bFNZOHlOQzI4bzQyVmhBQTdBNlVyT2d1WTJa?=
 =?utf-8?B?Y2pEUUp4UDdZY0JiRE1lcWV3M1A1eDFsWnFXSUkwdEFXL2Y1WXd1WUlMcDdX?=
 =?utf-8?B?cW4yWC9xNmxsVndCQkZwODNRcDhEUHRURzBOTFo5cXEvTDhWQW9uVFA4ckJW?=
 =?utf-8?B?OUdVZFkrOC90ZjVFRHltQ1JGNkdqaUw5YnZVdnBGQ1VUclBjUzJFSjFYNTcx?=
 =?utf-8?B?MWRNUlpNMFczSnBFTkdPaHhRdzQyZk5lQzU0Smowa0FVa3VtNXFMMTl0ZXhl?=
 =?utf-8?B?NzdYUjJ6T2N0eTNGNmlrVWlpWVhMZTBPSkRZWkZkbEpjUkY5dmUwR0djUUhU?=
 =?utf-8?B?TTB6U2xGanE3RWZPYUxoWmRXZzF2QjQ2ZGRrL2F0ZktiQVFVSVg4KzNQQ0hM?=
 =?utf-8?B?Yms2WUVPT0Y5eERyMDdwbDQyQzFHNCtXUnhkWDZqUTJLV1pINHhpRklRWUZ4?=
 =?utf-8?B?aXRaZGRKVW1KLzI3TzZQVWtZb3J0NmQ3aFRKSlBOcHZ1NUovMlNCcXhTZ2hq?=
 =?utf-8?B?MCtONzBXSlg0ZlpVd2pFMlptUVRYWVI1WEFyUXl2UzN0RGJCd25hY3N2UlQw?=
 =?utf-8?B?cUJhYlRWYStiN3g3NnJqTGlkOUlaNU9lVFhKU3dqYm1ndWpBNHJmZUV2ejhU?=
 =?utf-8?B?WDNyU2VSeng2aEIwZ1dEVGVpcmNCdzdnVWFncTM5bndoZGIyL2U5U2Q3Tm03?=
 =?utf-8?B?YXdKZkVzWGViY2hOZkpzMHFBVUh4d3cwT3lyWHBpTEJLR3hiNXVScUhMTGxj?=
 =?utf-8?B?TUxKWVhjZjhiQkkyMWlRamhpd05TRlY5UklLc3FXMTFoNlkxY1RLN0tTUFRY?=
 =?utf-8?B?dUd4dVU3elA5NldkY0dmVmxndzUwdlpib1hYRHRia1Zla0RGeHlJaTFHcEg3?=
 =?utf-8?B?czIyMjBzM2w5RW43Q3lzMWlMdmY2czI1U1I3c0tGUVpvSURiSUZNeVNGaHhJ?=
 =?utf-8?B?NHphVnhXeHFzVE5hMktqSmpTUVpma2c3ZzF4ZlB5NmFJVHIwY0QzVHpqM2N1?=
 =?utf-8?B?b2tFTXYyOEludEN1ZGFDMXJxd0JTcU9XczJtWmJLam1ielJRRXRkTjV6TjR2?=
 =?utf-8?B?TUR1RWhrK0NOalNPR3lSdnF1U2dySjVzemlJLzFKREN3ejdLZjhLRkthaVND?=
 =?utf-8?B?M2pGRUNWaW12ZHBaUlRBZ0F2SDNDcXVMWmU0UElNT2FRTjJ6aGxrdTFiUFNw?=
 =?utf-8?B?Sk1qV2dja3lXaVF6WURVMTBwa0cya3F4QnEyTkNJc2U4cm1JMy9UYW9mbk1S?=
 =?utf-8?Q?TnLk=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(34020700016)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 19:29:39.9193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b6151e-048d-4fbf-2845-08de1b0f5522
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6181
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BD01140010
X-Stat-Signature: q6kkgbmfcq7acjip3uaxt1zc8seb1q3b
X-HE-Tag: 1762198182-940300
X-HE-Meta: U2FsdGVkX18WdnDzJJab7v5KV7C2mepdVKheXbsALmUpdbvLdbhV4z49J3n55/uWscGE6RHElFYlunN1BUbK3pXiI6HBeY6UQ/bGdKVyu/TDd+p9tRTEHMvCXglnhrySDfe4QZA/dfcfZQa+yCSV9kzHroczgPuoJ8oqF8T5SWxXWx8R3hCrZOP3O9wKTG1IKTLu8zPtvTK2eIErkH/mZCnsq8VKF+TbMfEuQtNU+oumz1OhwyxwvpJ+weHpqGSGFqrg/Wu+3LFpl6o7LBNa25/a35zXyVbyPH7CMUV9pXsjLLKwqw/kdVh/uXHoEiwCxD0zp4RAojrqD5mHbnyHEBFgZrChWSMZN7emC2uRO9hgebQSn7GtCOq1FVBFpjv1dWOFFFLOKZoa1eFL0AsAtZdmZJqEAXpz2b6s0cQAagS9PmaPtrySjxiLHoU5ylOGfwtJ443LeH6fNyHUtFuXT6wd2NKzGtitbsQUYpByNronIz3dAT8UXLzMp4kk/n/8RAfiSZxgEKluHfi4NtfrV5hvSSGDr+ZpFBkassaEkghbUT7kMOnFPtPT5s3zlwV/LqkClhm9uqOQzLe2tvG9GrtLtusx9kU5+KE5MMsyBl0CQJ6/YZY2J7WLuPsqsq8BgcZYknv84H3pWxAINQ/BSp2A9a/KsodWcpquh5YCvaAKJ1eFjsaoPJ0owPC0YXnCOplEF/6mRoxXF8xcaSAX1nwj/Y+CRHa5l5c7WBgRMGs82LKaDd7/StMelb0eX99ey1TEo/sMBTmTXfoHAQzzU+RxnUDRpQh68MRUAsLfwNjWKoUljonBGxpXRr5W8eE9tZJJlnznBD2yhIn7ZVNiMkPVnzB4m556IesL+lGKM1EKWbwXtqJs9H/PLkF9OsCuATa751gxdbupZnxGYEK1iUioCHEUW+J+GtpzQ4RRgIA1EfkM9Vykh2OrQCxnNaYfOA2LaszCmGsCVSZjF+c
 Ul64ic7A
 po2D3eRR1qvjACyBAc0UfU8vgzSTFBe1qJEiX8ImlEylpli8zI8WsjChkOX4TEb1yLVuR6EOA6ZGPQOGJMAUvUNPFgU7DsL4YGyzViCkOOMi/rvyJ6q/CWLhUW2PYqCsNeuKBpeamvVppt0Gc/eifeQZIGK0CR2kAijU8vHQAjOqAQQgevh64uSs1rM/zc0ZbrHi4FTa2NEYYEaVhDMWd+oFm/MWUGupYvb+OGgrAZzmvq0Ie6rupg3XymA459K9kWrtzuKFFtpLo1oN9teYyLTBlRYn1tiZ0vzDJV8JSncUykTVEMjzx628wWsfMBt2E2jUIBTPDlNky5jgAubGIkSD/+lYC/jtpFenIFTOOaR1pv7GEiv05d827PfWEfBAxttryU8mhojLis8mVSShqaKEoM5PqPsGp69T1HRC8hPuhMRyCwtfk+ntbfDw/wo08oTHQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/3/2025 9:29 PM, Catalin Marinas wrote:
> On Mon, Nov 03, 2025 at 03:41:03PM +0100, David Hildenbrand (Red Hat) wrote:
>>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>>> index d816ff44faff..125dfa6c613b 100644
>>> --- a/arch/arm64/mm/fault.c
>>> +++ b/arch/arm64/mm/fault.c
>>> @@ -969,6 +969,16 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>>>    void tag_clear_highpage(struct page *page)
>>>    {
>>> +	/*
>>> +	 * Check if MTE is supported and fall back to clear_highpage().
>>> +	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
>>> +	 * post_alloc_hook() will invoke tag_clear_highpage().
>>> +	 */
>>> +	if (!system_supports_mte()) {
>>> +		clear_highpage(page);
>>> +		return;
>>> +	}
>> LGTM!
> I tested it with and without MTE and it works fine.


I tested the above patch on ARM64 based TI J7200 EVM board.
Boots fine. Feel free to use my T/B:

Tested-by: Beleswar Padhi <b-padhi@ti.com>

Thanks,
Beleswar

>
> Andrew, would you like a separate patch or are you ok with folding this
> into the previous patch?
>
> Thanks.
>

