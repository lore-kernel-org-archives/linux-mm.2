Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CF90CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 16:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86186B0008; Mon, 24 Nov 2025 11:38:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C196B000A; Mon, 24 Nov 2025 11:38:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94AD96B000C; Mon, 24 Nov 2025 11:38:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 83EC96B0008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:38:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CA11160402
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:38:59 +0000 (UTC)
X-FDA: 84146059998.24.F3308CD
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012015.outbound.protection.outlook.com [40.107.209.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5278AA0008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:38:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oQKv+9O0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764002336; a=rsa-sha256;
	cv=pass;
	b=N2vbzPQMW1/VO8Vao0ZWTCRu56C9AuROhxoqL+BtV4jq2T1//fd2pVKO8soJXhOBEJAaxZ
	9TXL7FDDhT9qKX+Cjlw1wks6VtwCh9x1XvkXL7RW0q+kTcKa/JC6jC9tuOLaH2GKWAH5nH
	ybNbr8CwZIYuX4eELbd332KmtCY2DEQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oQKv+9O0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764002336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhuXqPikeGjVEdoEsST9hK2pofVJesxTxNaGjv7Djrg=;
	b=SVhhma8WTZLdxZ1pLbmPyrHEAfm9qYA4MQSa0XwV5rHx7LAT8c5j7ucrx6VcBRjMtcCq3O
	ivFcRlU4jQpFLFwvSYR0phcc74BnN2OF5YGkWWBwfycyQ+FCZUN+PZI89dVKUzESyReH8e
	a5tLgm9ASuux0+9a+F0mH6xF9kFne24=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y4+RuT4xhL7J9XYOWCP0E7ntzTTukzcPVz3V891LUvSw4Vir6TBvdQasDgz5tFGuMCY1mOKm8M9rcv0K1m+RlE06cJEbl4ypUavU0TX0NX0SW3Re5CQDJf8nvzcQtd6fNn213e0nNSNuLJsqlsbJSGHaQpx5bJ0F73dub+kx8oyjRiS0HYm5ELY9qbG1S1kmbdTrFxrcdl154fidzJRr00ffnIajgoCoDHr+PXOIYeRxJyyR68KmTWcwmT3cJ+/u66Ynm2QGc1VTMIEw3FN1pjLrGZuFFQT7MVlt2oe16codru2zdWsEjbg+Evc0KGH5YqTZBMT5yXZ817BSXdZf9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UhuXqPikeGjVEdoEsST9hK2pofVJesxTxNaGjv7Djrg=;
 b=lLpfPTwkhZpG7BQi/iMHX3aRDfOP6KfNp17EXE2IwdQyO8ozZ7bnh8A7nXVUF9SUHw3ixdg6xXGYNYmQP5kBp/BCba/03hNThlEyN9L8SiA9N7c2E+Ik9Dxgn8VyEb4O49PR6DD5TLa2WimALhjCcpajpxr6A+4daCJN35V2iktFYsBeAWgGMtaycUMONGqQKI3UpW2DpvNyM5Z9oCAaRZyOHTL3ksdxMNY9ayx8c5Rlv/yigDmUDlkB4L0g26saMUKkxmQJlXPrRnvRKsd4a+3p0txMLdNtidRB67ZFPo7yw/1qbLSmAND4Tbwh8fZFHZ3PMGdjRivPNes7aczUSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UhuXqPikeGjVEdoEsST9hK2pofVJesxTxNaGjv7Djrg=;
 b=oQKv+9O0lUE0wDUKl8iwb0fIbVI0KMZB+wYp10A+Xz1urHVNQ2GPIh8M94u2HhwYT2qrAPQtvfxSDGGth3LKz66zJVeQoMFo077cLVoUaL3DY2IdVIlDkv2U4dMIbaTdUjrXH02c1yHlyX4mbXi7rCoxGEzoCGM0GtiKwoex4kQjJ9B2t3HB3zE5ChdchmRBwklcl/JEMslbWtYrttC3v5tSQfmlVsdA08vZL8082mvhd/Z9i92bNMi8S9wPkd1mrCqy9InvsxplWgicgqf3LOlU6CA5gvEQG4KSzaRsEd0PicPzbFcneRbYSoeCbMJ0TbAecQgONIe6DY2JxrQ1hg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS2PR12MB9776.namprd12.prod.outlook.com (2603:10b6:8:2bd::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.17; Mon, 24 Nov 2025 16:38:53 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 16:38:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm/huge_memory: change folio_split_supported() to
 folio_check_splittable()
Date: Mon, 24 Nov 2025 11:38:50 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <F1ADDD27-497A-4F5F-9A41-2A14C08AF9EC@nvidia.com>
In-Reply-To: <60d27f00-20ca-4a58-9d32-ffbe55f69a1d@kernel.org>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-2-ziy@nvidia.com>
 <CAGsJ_4wyL9TZr141emBOBTKhN7oEJjeA7kFxhoBbi-cme-5tKg@mail.gmail.com>
 <60d27f00-20ca-4a58-9d32-ffbe55f69a1d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR22CA0011.namprd22.prod.outlook.com
 (2603:10b6:208:238::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS2PR12MB9776:EE_
X-MS-Office365-Filtering-Correlation-Id: 92910a24-73c2-4ebd-31c3-08de2b77f402
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c1JlZHlWcHF2b053TkxmZGd4K1RCSGxEOWxlY0ZVaHc3UUZ0ZmpTZVp5Vzd1?=
 =?utf-8?B?Y1k0UE53d29aUEk4bjJuWENYTFhBSDNWSUJVWHBUc0ltUEwvNlhjVjlVdVBL?=
 =?utf-8?B?YTVCbFJXREJsS1ZOM0lLYlk4OEFDcDZhZUxxcS9EWHlSV0dnNHp1Ui8wNENp?=
 =?utf-8?B?YTAyY0RtemN2L0RLWFU3d0M5cndid1I0cXZZOTJ4b1A3NVpVUWFTZVZjNHpD?=
 =?utf-8?B?WE1TOFk4c3J6VWRPQythSytyYW1TcWpHc1NiVFk3QnB3aW4xcU95VXBsQXRy?=
 =?utf-8?B?OEtvSHdTV2pIeFFvbkd0RTAxSFNMQlNxMCtITTFobDF2dWwwd1JJOUZ0dTcz?=
 =?utf-8?B?REZSbTBFSGZqRExMc1pqaE5UV2FWSHVDZFgxVWliMmE3VHhlNXhUakorbXdM?=
 =?utf-8?B?OWRhUzNSN0NyTWgvc1FoN0h5RzlSZnpWR2ptUG9XTVpKRjZDeXZqM3RBUnFG?=
 =?utf-8?B?R2FGRGlkZkhub1RCS0RlVGdwT28wOEhyU2VoTEU1U1FKTExtUXpPUGxDU1VZ?=
 =?utf-8?B?QVpuQ2JXa0tMYXpJU05BcjJENklMWmpuUVhEZlV2UXgwMERwVFNYdkx0MWxK?=
 =?utf-8?B?cW5jbUJ0VUxjSkpIUFJtYS9ZS1NoMUgwTDBkc0JVVk8xZVVtZWJOcy9YZDJH?=
 =?utf-8?B?OFFKbTBYbkhyenlDTUZXQm9jcnlsSW8rVjMxKzVmeThEZ3VWbVJrNFA0QzBV?=
 =?utf-8?B?OEhYU2tJYWVBNG5jbjZvMEpZNElNRnc5QjJDd0tNbHh6ZnI3d01zdGhjOEZX?=
 =?utf-8?B?YVNyR1o2MkVmc2pSM1ZhaFIvZHlKUGpDZGhIVUZZcllRbmdKRFVBcUgwUFhN?=
 =?utf-8?B?VG5vRDNuZEJ2cUhOY2w1bnhjTEVLVDR1ZHdZdkZ0WVdkdFRZbExtSHEyZFJh?=
 =?utf-8?B?NjQ1QVJQdlpYTGE2UEwxbFFwMnFqQ3Fmc2IyVmZ0Wmg1SEtTOTE4RkJpUDVt?=
 =?utf-8?B?MWx6eTVjbEhuR2w1MDVmUmZQWlo4MDVBYmtTZTJuRVdMNGtKL1g0MGVYazJM?=
 =?utf-8?B?U01wRmpDS3dIbXlMd0cwTVRWWHhRZXExSG4yRFhsTXJBL1prMGh1dVNWMGYv?=
 =?utf-8?B?N3dHakRMQVdocW9Sd25ITUVmRnBZS0UrV0wxbWY0LzVPcnl0a2VxVkgwWUtq?=
 =?utf-8?B?eHl5c1d3QkpIR0NIWW1FSURmS2twT1RzaTZZRVZQckhyMG9NOVNNNVZQNTJs?=
 =?utf-8?B?VWdIZS9YVVdQWmJJbXF4aVp4NGFUVEFGbDQ4c3dYcVl4V3V5SlNibG9vWWtF?=
 =?utf-8?B?YVNaS3dpNTFEQWFqRmdianZ3dHZxYTVEbWZpOERqWjFwYmtscEZCRTF0d1d6?=
 =?utf-8?B?a0tobm9FeVpmZFdvTGlNZ1hyU1R4ejQ4Y1haQUpWSWJFQUdIcTlRc3JLUXdi?=
 =?utf-8?B?YmgySmFGaXU3cGRyQzI0UlFwdmNZREtpdStuNG1ROWM3R09VZDdoSnBnT0R3?=
 =?utf-8?B?cC9mbDB4cmc5NnRsVVU0dVVSb29kaGF2M0dTWkdBL1M0YUdoUys5V3NGVmJR?=
 =?utf-8?B?clo4SE9CTjhrcDJQYjNFWkh0bVdNbFR3WExXU1o2WTBhdktwNURod3BtaXlq?=
 =?utf-8?B?YVlBZVhKWFZVMmlFVVVMUk0yczM5Rm9ONEJSSmJlYzVycm84SmpFamo2N3M3?=
 =?utf-8?B?QXduaDd5RnM1aUUyR2NtMTlrcVFSNGF2Wi9mbyt4NjcvYXNTdGR6d0djdWRH?=
 =?utf-8?B?UFdVVVpzUlhSV3J5aHJJc1RvWS8vUi91dGI5RDhqdmdnaU9yd3dKMmpXNjBy?=
 =?utf-8?B?MlVuV25FWXVWNVpjVjRhZldZaEd0UXBXVFQyR0RaV3dhQUVRdFhhYkEvcThK?=
 =?utf-8?B?dVNGdzZsS2RnV0djV2MzQzQyYWh4eG9yMW8zYldkUjlpTDg0ZUMxSVBXYlND?=
 =?utf-8?B?V0MxRlNnOHlRZFQyNnRPUnlpUVJyOVN1dHFGTU9JczNIRFljWmdIQVNuem0r?=
 =?utf-8?Q?SCqPz/3CMq34sd6W8EvicDb80R/l2F6E?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEJOOGxpYmpwWUloUTg0U3p3ODJlRW9rV3hoLzNkaFp1bFAyZ3lyRVF4WCs4?=
 =?utf-8?B?V1Z1dlBCSC9CQTB1VmFwbklUUHgyL0RaRWRqaXlLbmphdU12R2lJbVBhRis4?=
 =?utf-8?B?MFRRNzIyN01uMnA3WURrOU1zT1RqZW5YV29ndlFadUJFMk40SnNIajhTUkp4?=
 =?utf-8?B?STIvQnBUb01Yb0Y5K2xzMmRzc090NjB4QU9pa285dS9ScHhMVjltZjR5c0Vt?=
 =?utf-8?B?SUxnUEZ4OEUrSU5ac3ZFbFBnU054TFdQOXBUeDJXUDdKSFNyZkJiZXZLUGlP?=
 =?utf-8?B?Q1M1UG1CWnRnWXBPZUJkSi9xVmxDZTZTOFFrWkcvdzF1eGJRVUF3Y2xyZ0Ri?=
 =?utf-8?B?NVZQeEliZ1VRdmRDMXg2NzFyVko2VTdnZDRKemN4MEtlc0pmOVdmR2VSdjF1?=
 =?utf-8?B?WFRiVTBocE02b0xlSU5IT2d3RXBqeENqdEtIL21YZTBudmlNdjQzQXZZaWFq?=
 =?utf-8?B?YUsvV3BJQmE5d2RsWmhrc2RsSDdrK1ZGVmViR0FpNzhTVUtSR0o2ODZKV3ZN?=
 =?utf-8?B?dE8wd2oyTi9ZaituWEhsYnFsa0dza1hxMWZzNU4rMVFhd3ZJKytucjQ0TVNI?=
 =?utf-8?B?ZVoxL0JzdWwyWEw0b3F1QWFaWCtnMitXVzZJaGFKLzNWbXBhRzZWOUxGMUk0?=
 =?utf-8?B?VHhWcVBUclF4SUhObDlDcjFkQ1lJeWpvUmdmUHdDZGZKdVA2eHJhR3ZEeDNv?=
 =?utf-8?B?NFcrNzk0cFd3eHorRTAwbVB5QUxFUlNwSXhWYkFYZ2FZMUhaZnBuaXduMFJ0?=
 =?utf-8?B?WHY4c2ZDa29mQTcvZ3dvT3NaSkFvQzRkWDFVQTV4ZEVzQzdVVmM2WGU5WEsy?=
 =?utf-8?B?NzNRNm51czh0UDZjQUpMVzV3U3RYUms1Tmc1K254anl1YlBENmdkZExPbEI1?=
 =?utf-8?B?NklsbC9icjJQcGdSVWlSdDlWMTNacXJKNG9ENHgrdDVGNVl3ZUd3cnBiY0tV?=
 =?utf-8?B?UVRrT1ZwbXJBZWJ0SW9xMytXRnBTZUV4Wll6MFFnL2hLRTVqUUxBa2ZHdWFa?=
 =?utf-8?B?dVJnWlMzMXRLb3grdDFOUkpvVisyMEJudFYveFMvci92U2pyMkFFbFpDWkJj?=
 =?utf-8?B?YUFHWk5RYW5FMGl2Z1cxU3dnd0kzcTJCa290clhLaUdjZ21zaXB1anQ5dDRq?=
 =?utf-8?B?TXViSG9ieTF0bUFZMVJTMUdPYzdQcW5yMEVYZU0xNTgvVTEvNGhqeUlxdGhr?=
 =?utf-8?B?aFRSb0xSM1FNek9UYk8zQitSak8zZHh6NFE1dFE3RUl5am5Ec0c2d2R5WkZ4?=
 =?utf-8?B?WnJEUlVGQThUdFpNbDNWR0FhM0N0SXJ0N0RyYW4weHVOZTQ2YzlaL3F6elpP?=
 =?utf-8?B?NXd3TVM4UkJ3VmxKcHRHWExiRW1tVUxxM1ZDbSs1cGFncytwY2c5UENMcTgr?=
 =?utf-8?B?OXlUU05GR3VvbFA1Q2hHYnBlcGxSL25XYldyUXlXSGU5R3ZlaUJ6RTV6a2hM?=
 =?utf-8?B?RklqZThMdm5hMkNhaCtKQkcwbWNRZUtFUjJ4ZnBMLzdNRWhTMFhZT0FVRG12?=
 =?utf-8?B?WUFDNkIvbG1vclRrS0xGbUdhbkJqUENlTWlZQTJvb2gzOHM1NWZTNEpYNUhL?=
 =?utf-8?B?THA0Wm9GTkkrK1FyYXJIbXpTM3dpZDR3bkxDWGhId1NyVVlBU2RDSWdtaFd5?=
 =?utf-8?B?MXpXdEJZWThzVnF1SUN3eDR6dHRXQWM3TW96NzZYRk1RV2t6M0FBcXovZ0pk?=
 =?utf-8?B?c2E3NjJPYmtQUHRNOEVDeTBWWHBYUFM2Ri8vcEF5TWZtU0Q5eUk2dC9XVmVI?=
 =?utf-8?B?eEJUYzlBeEVUL093WEdIcWVrY1RlVGlETWx5ZElkTWJ3WHg1Rmp1ZG1Jdkhv?=
 =?utf-8?B?UXFSdVJrT2FoK2RDRXJVTFl0N25iSEt0K2Rtd0dkNnpqUXpRVlh6aTVWOXpt?=
 =?utf-8?B?MnRmNWVjcGovVytNYXVQZ2k0bHBjM29XN1hLTXV4QzQ4NXFrR3NRempiZS9J?=
 =?utf-8?B?Z3BzQ1ZIM1h0cVg1NWEvNFpHNkttK09nVGhXcUF2OWNaOEdIN3gwUythMzRV?=
 =?utf-8?B?ZTBtbnRTcU1DYkNKTDF0Z3dmcFk0WDN1YmxuSUFmTGY0WFZKbGYwbXlCRnBG?=
 =?utf-8?B?cXRTYXlwMzBZMTBseTY4VG56ZVg4MWwvSlNiaWFqWDlZY3dxTXpBeGkvS21n?=
 =?utf-8?Q?Q1ySdk6zXmClCDCoTslR5TDkN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92910a24-73c2-4ebd-31c3-08de2b77f402
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 16:38:52.9523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OZ6XKIGz2vpGqKknIvIxWBUMfO8KBIZEWIbUdC2TIG6veFjY1xSusfJrpuZxfU8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9776
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5278AA0008
X-Stat-Signature: yfr9dx4c1n8fuqcfd1h9uisded6o4tju
X-HE-Tag: 1764002336-88902
X-HE-Meta: U2FsdGVkX1/keCBKZdtBitr8/gsWFcRf3ECKrvWq5vs5OJg1RalX1K/vyDyztoiYMR59ug3V2gwHWKxyxB27n6bJZASW9yayp9axox7hKXf0SXuNcQNwNBzRMBT44XOmnDFg2FQXlPqY732C/+BLPJw9SlIMmZnPMIiu7lmuTy/JeR1Z8r8eUGMtgoTEFK1vAunaiWZOMch9TmbxymdeN+A8dOgUqvwJipWtacOz8leBpQEVFsoxJDv082uENEhwxv4sJdqGoW3Rec3iLSp/jvrTKLslV0nxfVta3+1VmiALZ5TpquP8r1VrAqI0PpXvYMHCwIWdjp3lfPBYFMWfJxutr1MXznxkxS3tFevwTuX4ObRtqe7fuWnIbOFM9ovyc1ctN3UGuNlWADCxE5MKJIM6R6fQVUpG4V02Svg0hdUCfBBU9mxqFhyblMyPKIt4u3QUbZHFQy57Q+AXzy955XLN+4QRftPre8iZ3JyZO59mdrcyRa5Y/92MwP/TDyfyOlaQQchI6bPym/ND8FIt2t3QBBBdrvo9AKEz43CWngIOE9sTtnknIOeaDglkCJYvALUdf5CRuB5nkkluVRE1IISlfIZbfIKhB/fc0SWVL8PtFnVxpO+2W0+Q7NFps+LEI6Jb/UIcAklS5NsL7ZIEhdY7Fvcp0ALy+M2AjO7XX8nieZluJV8FhbOxPDktjSzFz5KsbElWfl8cYdbLKfGnFVOtG+ALe2YzzzkIhPcikC3Se5KeBoLFnfgYSxY3QbwJ/VFeOhReTCOBs5vXxYUafu3ctVib7CRLXoLbIQTQtrYVimsK61ohMNgpiWRkCM22gCqkomMHwWzaLxDZqr3gyMq3ul9Z7CVw0tLutf+LWHyFdLXnxw4zffDv403cgRjU0tN4S2uaNDBRsNqWfgMruI57+cHtJuQB/+F5fMeHVsOyHUz8npEZFkUGSluEHjSIyncc4B17QirQB4wa9Jy
 mE1GSWky
 IvLtFaIST4O8+Z85RHwrVcM/MaxP8Thb4zzCwDrA9i/3Q9+VJE+MQNBZykaR3R9LYLRm4aaMkloSp36BfAzI0ttinHok2kSQbH6Fl+miua0MiN0zMh+aV2RxFMplOP2aRrNAvDgcHNkXGw0B8rhgIJpPtfoMlp8i7lUlZfll2Sr1+60LZpDE5G3OK0bswYD36X7lonSQ/42Fp7/4CrEDuecnWzgNz/h7AZagvPZ7Awtsy0IGmkPNx4Ete8KpUFpuCJGAIZA0slcwnsu4wg21kR/XiEWMSUC86iYdNb8ohLME+MAzT8JUMPoO9gcQsZ+CnfbPrn9rHNzH6Opce9xZdEeTOsfBKPM29j3MnNYgGv9jEdLETqetRyrswj21MePKkxcC8AiauZRONV1+6rp4bm3LqQzI9IVWQRNJlDdH3UV/8ILf+/dTT7YdT7nqzdfgTgCeNKx1eLl5JK5Uk3FTdmASKLi6Cug7lNgELtb1IqA/aUgFgJEF4nrBE+IEEn023k+bstlSQquajHsE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Nov 2025, at 5:33, David Hildenbrand (Red Hat) wrote:

> On 11/23/25 19:38, Barry Song wrote:
>> Hi Zi Yan,
>>
>> Thanks for the nice cleanup.
>>
>> On Sat, Nov 22, 2025 at 10:55=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>>>
>>> folio_split_supported() used in try_folio_split_to_order() requires
>>> folio->mapping to be non NULL, but current try_folio_split_to_order() d=
oes
>>> not check it. There is no issue in the current code, since
>>> try_folio_split_to_order() is only used in truncate_inode_partial_folio=
(),
>>> where folio->mapping is not NULL.
>>>
>>> To prevent future misuse, move folio->mapping NULL check (i.e., folio i=
s
>>> truncated) into folio_split_supported(). Since folio->mapping NULL chec=
k
>>> returns -EBUSY and folio_split_supported() =3D=3D false means -EINVAL, =
change
>>> folio_split_supported() return type from bool to int and return error
>>> numbers accordingly. Rename folio_split_supported() to
>>> folio_check_splittable() to match the return type change.
>>>
>>> While at it, move is_huge_zero_folio() check and folio_test_writeback()
>>> check into folio_check_splittable() and add kernel-doc.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>   include/linux/huge_mm.h | 10 ++++--
>>>   mm/huge_memory.c        | 74 +++++++++++++++++++++++++---------------=
-
>>>   2 files changed, 53 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>> index 1d439de1ca2c..97686fb46e30 100644
>>> --- a/include/linux/huge_mm.h
>>> +++ b/include/linux/huge_mm.h
>>> @@ -375,8 +375,8 @@ int __split_huge_page_to_list_to_order(struct page =
*page, struct list_head *list
>>>   int folio_split_unmapped(struct folio *folio, unsigned int new_order)=
;
>>>   int min_order_for_split(struct folio *folio);
>>>   int split_folio_to_list(struct folio *folio, struct list_head *list);
>>> -bool folio_split_supported(struct folio *folio, unsigned int new_order=
,
>>> -               enum split_type split_type, bool warns);
>>> +int folio_check_splittable(struct folio *folio, unsigned int new_order=
,
>>> +                          enum split_type split_type, bool warns);
>>
>>
>> It feels a bit odd to have a warns parameter here, especially given that=
 it's
>> a bool. I understand that in one case we're only checking whether a spli=
t is
>> possible, without actually performing it. In the other case, we are perf=
orming
>> the split, so we must confirm it's valid =E2=80=94 otherwise it's a bug.
>>
>> Could we rename split_type to something more like gfp_flags, where we ha=
ve
>> variants such as __GFP_NOWARN or something similar? That would make the =
code
>> much more readable.

We do not want to make folio split complicated, especially the long term pl=
an
is to move to non uniform split entirely. And this warn parameter is solely
for CONFIG_READ_ONLY_THP_FOR_FS, since large folios created via it
cannot be split in non uniform way.

>
> Could we get rid of the "warns" parameter and simply always do a pr_warn_=
once()?

The issue with this method is that truncating to a large folio created via
CONFIG_READ_ONLY_THP_FOR_FS triggers an undesirable warning.

>
> As an alternative, simply move the warning to the single caller
>
> VM_WARN_ONCE(ret =3D=3D -EINVAL, "Tried to split an unsplittable folio");

It sounds good to me. It at most needs the person causes the warning to
add some code to find the actual violation.

I will do this in the next version. All VM_WARN_ONCE() and pr_warn_ratelimi=
ted()
in folio_check_splittable() will be removed and __folio_split() will
do it when ret is -EINVAL.

Best Regards,
Yan, Zi

