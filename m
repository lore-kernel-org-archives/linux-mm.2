Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A47CBCAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96C08E0019; Tue,  9 Sep 2025 11:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46118E0003; Tue,  9 Sep 2025 11:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC07F8E0019; Tue,  9 Sep 2025 11:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B62FE8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:32:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5BEC81DF07C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:32:28 +0000 (UTC)
X-FDA: 83870103576.19.B78E6A9
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2118.outbound.protection.outlook.com [40.107.96.118])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3BB814000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:32:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=rNT9Ew4u;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.96.118 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757431945; a=rsa-sha256;
	cv=pass;
	b=3UnoKvSMmxDmusgRzIhkzY22qtDmWrCLd2SPejSRk5HUvsotkvIwNJTceJLoSBB8Lp5orP
	x3lLw+N0bVZ5GxetIC2IiyywJfRqe7X2pvbgUOHJEIJpPdIHAtX+72uxqP8+AijbfIdeFa
	lg5HAqy81K4ig8fRJSk86O+oubNMOtc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=rNT9Ew4u;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.96.118 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757431945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHxzYcnowHA64IK04GCOWxnV74PwcV9ahri8ck0ZIwE=;
	b=f1Ip4E2Qp5WZV4rqTV7TCejtUl4e+bUbA/Jo0D47SaXh6QeU46aByZF85DL+nUOWx0tXJ/
	LqI6HXz6zOvDO6u6zvcYzqB6thnPpaoETGboWN4Z9+ZNHViMAPVCVHFacofRzOro7McaEb
	fBlzNWxVsjf5YigEPeb31EXmEhga9y8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hbluEnUrDn+FurW2h0arPJuTeDRkWGJzWAi6/iLqOo4kXT3yr9Eo+rVrVVmYJ4ESvKF5RfqhOs/NHtMb1ConkEPeRv9JiTYxgScOhXlrKg7RGro4quwrm4pzXaBPNuzQPzMiPR7NCAAxx8/AIM8qsnMiBDS5jYxSHLA794XLx9GVxMxcFHCCS8nHYJ812MmAnIgsiBMQQXlIV2/5d/OvLhsdSL0T7iS2sqvzEnbp161CfbPQCYM3XhXeDIzvx7vlHq3VD5VphHOQFLdUrcf9/LCGZY6m41cS8/JWEJ5ZRV24QwCySnLsyfW32pBPGd6HbvC3NTCaW8ck6CwdZNEPdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHxzYcnowHA64IK04GCOWxnV74PwcV9ahri8ck0ZIwE=;
 b=zKPZf9hW/PehYy908CvCzoErSJ64qArGS20kdI1Qgf/qYU6tDuYM9+8UUrDGVG3aFXHCWPOTLQSlrYQETa4yo3HwCpI9LVbMyOQaC3/2mwtbS7+CTBkaSZchRGFMcTDjsV3H9nqTDI81PKrsY/ILMsF9B+kLQm9CcM7xMb92Afglxsd2rq+cudKLuQx3If7Zsltes7FL/UdPwWq4D07Lc3jsaUi10gZNt9fqfDHoaiobHB5mp+scW6DTgPBPMmiMdLtSJM1pnBup/UxVRxeFXYKSIT1CZXASnn6e750MjT7BJfumbaxOVun8IXBg6aO6htRqtelZ2nrJ9Wo4X2M6vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHxzYcnowHA64IK04GCOWxnV74PwcV9ahri8ck0ZIwE=;
 b=rNT9Ew4uSR/f8qYdW+fytL1lK85fyQqYH8sqJmOBZGqYKJY6Uhg4qMvn8EgL4PUaXv/eHJG56DRa849ERLYFF8VtwTByZy9WAOyXyimkPI5/CgddJJfqacatd8QK4Z9LtfjHZekKJtZFYt/3zG3hHm86bqv/8DCzDQhtwwM+wiE=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 CH3PR01MB8540.prod.exchangelabs.com (2603:10b6:610:199::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Tue, 9 Sep 2025 15:32:18 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%2]) with mapi id 15.20.9094.018; Tue, 9 Sep 2025
 15:32:17 +0000
Message-ID: <4aa4eedc-550f-4538-a499-504dc925ffc2@os.amperecomputing.com>
Date: Tue, 9 Sep 2025 08:32:13 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <e722e49a-d982-4b58-98f7-6fef3d0a4468@arm.com>
 <dd242f5b-8bbe-48e8-8d5f-be6a835a8841@arm.com>
 <aeb76956-f980-417f-b4e7-fe0503bb5a2b@os.amperecomputing.com>
 <612940d2-4c8e-459c-8d7d-4ccec08fce0a@os.amperecomputing.com>
 <1471ea27-386d-4950-8eaa-8af7acf3c34a@arm.com>
 <f8cf1823-1ee9-4935-9293-86f58a9e2224@arm.com>
 <bf1aa0a4-08de-443f-a1a3-aa6c05bab38c@os.amperecomputing.com>
 <39c2f841-9043-448d-b644-ac96612d520a@os.amperecomputing.com>
 <d7cd4004-bacf-47b0-9cd8-f99125e02238@arm.com>
 <fe52a1d8-5211-4962-afc8-c3f9caf64119@os.amperecomputing.com>
 <8c363997-7b8d-4b54-b9b0-1a1b6a0e58ed@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <8c363997-7b8d-4b54-b9b0-1a1b6a0e58ed@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0125.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::10) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|CH3PR01MB8540:EE_
X-MS-Office365-Filtering-Correlation-Id: a4b9a288-0d2c-49ba-e276-08ddefb60f53
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWNRbXpEdlBMR09udFNiRnFOVEdvSkhpTk5TSXNZcUwzdmtCc2NuT3o1S3RU?=
 =?utf-8?B?ZmE2aXVReDRCYUJmVDZpYmhLdEpBclhIc0p2WnFJdDZLMzlmN3gxZFJDV3Qx?=
 =?utf-8?B?NUxDOWNSWkJlRTFiR0dXVTlvR1doWjBvUXZPbWs3SnFUcENqaTd4WW96Z3JM?=
 =?utf-8?B?WVJnelEwbnJhMVUya1J1VUxpSjE5ZTNhWkx5Z3dtaVZJOHJoYmowa2ZobmJm?=
 =?utf-8?B?V2Z3ZXpEU0RlNzVGNkxGZWdpU2lkZ0ZySWZuY1BZWjNyT2NDWnNrNTRJMGwz?=
 =?utf-8?B?U1hwUzEvUWI1NjJiYTQvdEk3TElGMU1WK3dsNUNvcGNDb1p0OFpIeXRyZlFY?=
 =?utf-8?B?ZTVzMVBEUGp5U1RVWWQ4d1JJUEJlV1BiN2NUdEk5NEVJTXJaUlhlWXA2Ymp1?=
 =?utf-8?B?OHU5UnZlaDgvb3N6MTE5a1hQTDczaXY1Z2poc1picEh2ekdxQ2taZXRCZTBJ?=
 =?utf-8?B?WWNXVmZuc0FCbGFGN091Ulp4cnkweUJCZ01IZDMyYk1lamZUOHR1VXVnd29m?=
 =?utf-8?B?TEkxQU1rU3o3MXNVejNXTndpRFBHREV3Tnp1Ny8yZE4rSDlOaXVXdFNnMjVW?=
 =?utf-8?B?U25PbXdjMGhLd2pWd004K1NPSEcxcFE1NzhkOXoyTy9MczNHVFYrTjdCSWYx?=
 =?utf-8?B?WXlhUGFVa1dPcWgzd2FDbytZZUQzYmk3QlBjU21MTy84VGVDNTNkSC9NcEdV?=
 =?utf-8?B?bDRyNTRuUzF5bXBqYVNoWHV0RWZFNUFPNUxTai9ld0M0U2lkSWdWSnBlLzhl?=
 =?utf-8?B?VzNnTU03UlJKdG5EUk1yK1BDeUtvdkl2UU5QOVpnK3FtZVdDYjZnWldrSE5O?=
 =?utf-8?B?bjVTK0d5Q1VNTHNrN3p0bmZqRWRUOVBMeE9mQ1Q3VUZ0WEhjNnEzVzJDVXV4?=
 =?utf-8?B?Vnl3TW5maCtaZmhBYlRyekIvbHRXUmdMNXdTd2c0ZEM2QnQrOFlWTlJvNlB6?=
 =?utf-8?B?elZnUlVxV0piei95NDhnY0NCSnh6WnBtTGlXam15T1NsS1FYK3VKT0xXUUhR?=
 =?utf-8?B?Q2hWbVlqbVlWVWRKQ2RXeHcxdVdzUysrcnhualRHcG8wdHAzeFBVcFhCTzYy?=
 =?utf-8?B?dm1RUHBMTGJMSHVhZnhDVmtmNnowbitLOExYMHFLdGcyMkZ3di9nSEtUN21k?=
 =?utf-8?B?OHQrekFYMlA1Sm9seVVsdkdrdVN5Tzhuc1dvM2xQeDVzM2dLa1ljOWxOYnZ2?=
 =?utf-8?B?N2ZiSWhMTXdkeVVrZEZHbk5KRXRvYkJ6K0tjakg2RmZCamFmVnFRYllodzh1?=
 =?utf-8?B?ZHVna0F2MEMxdHhoTUI2alcvdkxLRmNjaWk5MmxvaWtzaU1WdGFuNG00R0xo?=
 =?utf-8?B?N3Exc21ZWlRyUzhQcTlYTzBTRkxORzVTa2tXN2xnYVhPS3FsWFhnRk5HODk3?=
 =?utf-8?B?N3liNjZJQkMzUExUZEZ6OUNocVRVNTZ1VEp3bEEvN2k0U1JRWXYxV3UvZGtv?=
 =?utf-8?B?Tkc4VGI0R0VEWmtmYWR5elJkcE5SV0Y4cHhNU1hITG40WnlObmp3aUtBMzlw?=
 =?utf-8?B?QnBnY0ExT2N6K1NKMVBKTTFscGo4K3R4Q015WTdIN2czV3ZyS2lYRDFFa2tk?=
 =?utf-8?B?RlozYlA5WTAxR1RLbzNSbWlGVjBQelZKa1oycmhOWWx3TjNXc0NQZG1RdC8w?=
 =?utf-8?B?RXhXVDNMb2NqWmVDR1k2K1NITGxpL1pQYzk2a3VDY3h2OXBieGtvT042Y3VV?=
 =?utf-8?B?ZzZVa0oxMWFlSklWYXdxbi9aK3p3VzcwUTh4TTBieDc0Ky9DeVZqMFo0a2VP?=
 =?utf-8?B?c1dDa0c1ZFBIRGdrWHp5YjhpMDBvZTEzWC9NdVNpZDVoUWVzdVg2QzBvcHBI?=
 =?utf-8?B?WGcwS3hJSDFnaHhvRzRhQ2V1Ui9ZZHdnM2pNSWl5NzJGWmw1UnJ5Y2lOTjAx?=
 =?utf-8?B?NjNmdGpKVThiUkRNNHg5T1RhR3c3MFZzazVOUGVabWpNSHVNWUlmNUk2bk9H?=
 =?utf-8?B?T08yMWQ4ZVhDdUl2ZThQV3RPVnFURkZaSEhmWGdRbzg0QVVtRklRelIyOEtr?=
 =?utf-8?B?SGowT0xlQ0RBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWJFYUhqc0UyZnduRUdtcC8rMHlWSVEvaGhRRW9STWRqR1h3bHljbTlCWUll?=
 =?utf-8?B?TkNJSkVGZzRHYnZSdDJkTW1MMDVQT0dOZE40R3pvdDc3YUVvWThUM2RIZmhB?=
 =?utf-8?B?WDNIbW14UStNTUozVWJDRFhYQjBOSVpxYkUxNmpHNzRZSEt0OVdtUTJDWFVN?=
 =?utf-8?B?VjFVTnA4ZmdTUDBPUlBOZ3EvSnNkb3ZGR2I5eC9takIzeG1mK3ZkWm1vY0Y0?=
 =?utf-8?B?TjhmTUlNT0MxSmlzOWZBY3lwQ2RLUTBjY2NJOE55MWNVN1VGSGtyUlNHbUI0?=
 =?utf-8?B?eVpkbVNoRDlEdFdlbm9ZamFNb2pockVPRWVzaHVUeVdhRmQ4cEwwRjJ1clVt?=
 =?utf-8?B?YWV3cDdVWnpPWlJFMmVHYVdoTmlvM1FrTGJFb3dIaFcxOVhSY2tMN1FjbWx5?=
 =?utf-8?B?eE5LbCtvTERjRnBFSjRBWUQ4NkpnYlM4WXRwVytwSkwyVHFQMkc4Qk0yK1po?=
 =?utf-8?B?aTVoRFJsdjd4T3g0NlZ3bmh6OGxhUEdUU3ZGY0FWZWJnMEtYcGhXTVUzNEJM?=
 =?utf-8?B?NHE5TWdYd3YwajB5ZFpsb2VIekVvRXIrNnM5RGhia0lPUFVkMGI5QzI5WGsr?=
 =?utf-8?B?bXJYTzRGb3NESHRmc3RPL2l0bklQMFY3UHl5MFRIZWwzZUxGeXZnN29UclA2?=
 =?utf-8?B?SHVHL3lXQ3JCVWxIZXVsRnpJRUgyd09RSnJXbW8wQXN4M0cxdmp0WVJ1S200?=
 =?utf-8?B?ZXgxYXoyeDA1MlNpT2VPRXpsSnB1VlZFNDdCQlZCYnpKanNIKzRMdDVoWFA0?=
 =?utf-8?B?dGxIeG45a2orclRmRHRSY2NQSWNvSCtTQUtTWTJ3cno3RURWWktEekRUZUFG?=
 =?utf-8?B?a2psZjh3bGJxWVprTUNCSVBucU5NNjhIdllTMENXNzVpQmIyUjdkbUpnSW4w?=
 =?utf-8?B?UWNNZ3RnSTRxSWlDWVBmcnladlV0Y2VxRGdTZGkxWFZaeEZQWHJqQjZyNmwv?=
 =?utf-8?B?NFUrYk5TbjZnbldnYjUvUE1SM2Ixbk90RVExR090bXdLdE9Banp1Y0drbHU2?=
 =?utf-8?B?eVZjZWJyeTY1T1ZhRlN5Q29FSzd5bG5ENk9VUGVXeG1Wck12VUZ0U21PQzk4?=
 =?utf-8?B?VFhIQXZqTS9mMmlJS0NTcmtPNis0MjZ3QTUyK09tM1A3Mkh6UWxUN2UzSmxT?=
 =?utf-8?B?QjNQMW5jUXM5Mm83N3NMcVI2bWpxelQxWFVsU1R3YmM2NTNuVDl5ZWJvY1p4?=
 =?utf-8?B?MVpaaUxYOWljZjkzSG9rUmExZStpTlloRFNMd091cHhMTVdzOXA0U1FNeFV4?=
 =?utf-8?B?UDkxeXJBSHJabzcwNjJGMHJ2SE9weFdEa0t5N0ovNm5oWnNZY2N1MjBKZXRK?=
 =?utf-8?B?V0lKODIrUVcram9QWERYRFRoVW9XSzVjMkprVVJuUHZHNXVKdGdOb2JhZnVB?=
 =?utf-8?B?MzhzSFdPRnRXd0NIeGttQjJyZFEySjBicHdaTXQxak4yeXZmZTZVTUNWSWFW?=
 =?utf-8?B?Q3hYN1ZvZXFRbUhPbm4zMExaTndHakVQU0tpWUI4OUlvZnZDcEJyOUJxWVY0?=
 =?utf-8?B?N1ZIdFRIU0JjQXV0L0Z2SzQ2MW1qRnVXa0lMSFdwZDR6MkpUUks1bk5JbDhv?=
 =?utf-8?B?MWRzdnRhRDB2NWtTZC82LysraDR2WmUwY2dNUkF0RE5kZUplWFZnY0JFK1da?=
 =?utf-8?B?MVFYYm5xNG5LOGFqUEVKSFBOUkVDdzJ5WERqODJ1SUFXdEkyRGtKdDdZMEF3?=
 =?utf-8?B?dFlVZHZ1N3hXL0sxVFNPejA4UDhTZFFXd20xYlFwUGpjMUl4ZHAwaERZNi9L?=
 =?utf-8?B?b2xCRnF3REZrN2Q0cStTTkM4UzB0SVIvNHZSZ0JCbDNKakhMWDF2QzRCSDJu?=
 =?utf-8?B?OGJSamtxV3hOeXQ5ZG1GSFhlQU44eEZnUExOV0pKZCthRFBYb1pZUXVVNTFC?=
 =?utf-8?B?a0gxV0dLR24wT25KYkZHV0dpN051VW9mQnVHckxKYVVXSHpxUFdPMmw4TFVN?=
 =?utf-8?B?TjVCWmxmREhtdXFHTXVRU0xIdnBBejJUS0E2cGNrVkNYdE9vazZobFFodkRY?=
 =?utf-8?B?Yk82TjRMd1Z4YUQreU12aVk4akMrTW16ckZ4ZlZON3NrSG9DSXBBSjY4N280?=
 =?utf-8?B?L1Fldm0ydm9DT1kxdmV5dXVNYXAvb01KK1ZWcUdzb2hXWDRRU2x6SlZFSDZP?=
 =?utf-8?B?NTBaVFJ4MUM2TE50TS9oNzE5NWFzeDMrT0F5eW9ZSktCdFhDQXZZZ3ZFNElR?=
 =?utf-8?Q?RuQWifphhSd5FbyBZikY2nk=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4b9a288-0d2c-49ba-e276-08ddefb60f53
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 15:32:17.8380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KxoyV7CQO/wHuh9dNigT1+gqYcl+49+fI9xdxOLbIeMpOMPrWT3ThH/xQB7i45gnuv1isYlvGAnQzikE7Kz8hK+N2ur4W8wfsvW8ZT0NF+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR01MB8540
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3BB814000A
X-Stat-Signature: 6ojtwes6rgfj5j44jdi7m5zxij5fb77i
X-Rspam-User: 
X-HE-Tag: 1757431945-566729
X-HE-Meta: U2FsdGVkX1/46ymhXoy3pdQfPMVTfPv1wAmqL4/QDluz+8hPK40ZoDAUKrzQuZWWTAQgxSrR+zUEZk9Opo/Bp00yVrpd2QunUhYylbNVcJlwmJhmGxshaTT0+yvyd3FZZfCzEMn58+RecKUQxMhsD8M7MUb4Bd8D76lw98Ti9xCBRhC7+zXhOJyX203AFHBrgSQbCUmCdaWktUTxBfuOmZ3WzxyfzyCW4EGQkG50lbKehuQbm/Tb6errIiBcMesYVNbdaqIt94/ZJYXBkpXoFp0qCmM1OQhmcMaysMNl5sjFZgPJLl2RGZnBbXKvn/aJkp6m9+ro+DORO35uIT1HAbjwLUMA/sw3aoQS4XfnmzAOODMGrYx7vWS7VU3fwrk1ktkcM4JMdpKeMVLUB1sNcNIltjcrjGYzjWJ7wb08O3OPpiIls2lxqmCPkS90HkEs815xSBwDGMyRQWZdZR4xnIPp6V1E+jYM1U4JALAQCuTtPTHfPS4fkpFB4fD75P5qdL4mODia5bgluTX4HV/dU/9P9wz2xgfPV63t5NlwwaOjEPaWBXXD1XxARjbM2MKABamLPXWiHXAohEcTgJmH97a4cKeutz5S7+YYVGh6yeJ02VgmFhF41Aizgtaaiuyj++PD+zk/e3S46O3cz+aSfwucRy7ZAxPQRTcf5z+0zo6NazQtAot6zqQWfE0eX3hT1CSTbZoNcbgEd+TZfq27vNXcllroNWPOmHv+WJYqJXLgzCD9hB6USK58ZewPGlPhRBNu1j1FuiQTk0tKPLC1meZdv5lwsoQwD7BbI1vLYMM/gig2lXVN9aT7I7fpxlgR2/An768kqQ6OA52mOigG0288+WlgPNACTb5YXqVG0dxGrbVq8n7hKXoGZ8Mbp6OcZI7X40rDnTPwvukt+6mWQEYVEtV5VqMZsvR2cvdpyZ4GlBOMYH1OccvK4QqLlwMh/EkcVrU3jvdnHxKmfh5
 TMP5JK//
 7aJTk+JIkWlFgf4WkP+nJs3mT+b6r/Eq1+FmXqc/F7P9KZtjXou0+hsSQlT2YRAqjxO7IpdfLHrfwXr7T78uPNTchEqkNTqUcMuWeyCbQlmRLjyxAGWu7rBhAZj0IlySpFX7HgljS3G7ROhbMg35DHvzJdfGjye6sdUSJt83xc8OhW6CZ6YQ0EkEuy4nZN8FCnI/JmuxjPzMufq1gRHEZ5ziSyB+Ry05iH4XrmYupAF8xz0LPXCF9fmzY1p61L1FcDohXY6bvIDJfkXtASSz5WKrRdJjkA0fbyTOgEFCEyDYanryGX1RD0Lb8V2KojQkpU6NRyDa8txYUl5SF80MH8el7iJDMnSjZO7OSi/UWy/SR1kgVlc9h5NYOH6jErHvVlNaWOopYBGCX6oeBFD7TFkpCu+mzkcOoAca+vw/IQ5aKj7yn1WH11p+Uy/QGr4/3YRU11f4Gsgutv04suX4MDVaFMiOKUbcLAK2x5Alc9wPr0jGz305FQgj+gmCgCfsEAwtNUP1E6wE7lxio07LT+iMluLw85XhR8HXMcf2S3H9FFJxfTAJRFbrbLWwo9fMh1/n7H8sE80wuJdXLqT/hPgWaUFfJAwBG8crJSSrnG0p/QmxJLBWQJUO3srcZF6Dsow6oZygQqwOj16HzBJC5dAi67zg36pn9h9fq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/9/25 7:36 AM, Ryan Roberts wrote:
> On 08/09/2025 19:31, Yang Shi wrote:
>>
>> On 9/8/25 9:34 AM, Ryan Roberts wrote:
>>> On 04/09/2025 22:49, Yang Shi wrote:
>>>> On 9/4/25 10:47 AM, Yang Shi wrote:
>>>>> On 9/4/25 6:16 AM, Ryan Roberts wrote:
>>>>>> On 04/09/2025 14:14, Ryan Roberts wrote:
>>>>>>> On 03/09/2025 01:50, Yang Shi wrote:
>>>>>>>>>>> I am wondering whether we can just have a warn_on_once or something
>>>>>>>>>>> for the
>>>>>>>>>>> case
>>>>>>>>>>> when we fail to allocate a pagetable page. Or, Ryan had
>>>>>>>>>>> suggested in an off-the-list conversation that we can maintain a cache
>>>>>>>>>>> of PTE
>>>>>>>>>>> tables for every PMD block mapping, which will give us
>>>>>>>>>>> the same memory consumption as we do today, but not sure if this is
>>>>>>>>>>> worth it.
>>>>>>>>>>> x86 can already handle splitting but due to the callchains
>>>>>>>>>>> I have described above, it has the same problem, and the code has been
>>>>>>>>>>> working
>>>>>>>>>>> for years :)
>>>>>>>>>> I think it's preferable to avoid having to keep a cache of pgtable memory
>>>>>>>>>> if we
>>>>>>>>>> can...
>>>>>>>>> Yes, I agree. We simply don't know how many pages we need to cache, and it
>>>>>>>>> still can't guarantee 100% allocation success.
>>>>>>>> This is wrong... We can know how many pages will be needed for splitting
>>>>>>>> linear
>>>>>>>> mapping to PTEs for the worst case once linear mapping is finalized. But it
>>>>>>>> may
>>>>>>>> require a few hundred megabytes memory to guarantee allocation success. I
>>>>>>>> don't
>>>>>>>> think it is worth for such rare corner case.
>>>>>>> Indeed, we know exactly how much memory we need for pgtables to map the
>>>>>>> linear
>>>>>>> map by pte - that's exactly what we are doing today. So we _could_ keep a
>>>>>>> cache.
>>>>>>> We would still get the benefit of improved performance but we would lose the
>>>>>>> benefit of reduced memory.
>>>>>>>
>>>>>>> I think we need to solve the vm_reset_perms() problem somehow, before we can
>>>>>>> enable this.
>>>>>> Sorry I realise this was not very clear... I am saying I think we need to
>>>>>> fix it
>>>>>> somehow. A cache would likely work. But I'd prefer to avoid it if we can
>>>>>> find a
>>>>>> better solution.
>>>>> Took a deeper look at vm_reset_perms(). It was introduced by commit
>>>>> 868b104d7379 ("mm/vmalloc: Add flag for freeing of special permsissions"). The
>>>>> VM_FLUSH_RESET_PERMS flag is supposed to be set if the vmalloc memory is RO
>>>>> and/or ROX. So set_memory_ro() or set_memory_rox() is supposed to follow up
>>>>> vmalloc(). So the page table should be already split before reaching vfree().
>>>>> I think this why vm_reset_perms() doesn't not check return value.
>>> If vm_reset_perms() is assuming it can't/won't fail, I think it should at least
>>> output a warning if it does?
>> It should. Anyway warning will be raised if split fails. We have somehow
>> mitigation.
>>
>>>>> I scrutinized all the callsites with VM_FLUSH_RESET_PERMS flag set.
>>> Just checking; I think you made a comment before about there only being a few
>>> sites that set VM_FLUSH_RESET_PERMS. But one of them is the helper,
>>> set_vm_flush_reset_perms(). So just making sure you also followed to the places
>>> that use that helper?
>> Yes, I did.
>>
>>>>> The most
>>>>> of them has set_memory_ro() or set_memory_rox() followed.
>>> And are all callsites calling set_memory_*() for the entire cell that was
>>> allocated by vmalloc? If there are cases where it only calls that for a portion
>>> of it, then it's not gurranteed that the memory is correctly split.
>> Yes, all callsites call set_memory_*() for the entire range.
>>
>>>>> But there are 3
>>>>> places I don't see set_memory_ro()/set_memory_rox() is called.
>>>>>
>>>>> 1. BPF trampoline allocation. The BPF trampoline calls
>>>>> arch_protect_bpf_trampoline(). The generic implementation does call
>>>>> set_memory_rox(). But the x86 and arm64 implementation just simply return 0.
>>>>> For x86, it is because execmem cache is used and it does call
>>>>> set_memory_rox(). ARM64 doesn't need to split page table before this series,
>>>>> so it should never fail. I think we just need to use the generic
>>>>> implementation (remove arm64 implementation) if this series is merged.
>>> I know zero about BPF. But it looks like the allocation happens in
>>> arch_alloc_bpf_trampoline(), which for arm64, calls bpf_prog_pack_alloc(). And
>>> for small sizes, it grabs some memory from a "pack". So doesn't this mean that
>>> you are calling set_memory_rox() for a sub-region of the cell, so that doesn't
>>> actually help at vm_reset_perms()-time?
>> Took a deeper look at bpf pack allocator. The "pack" is allocated by
>> alloc_new_pack(), which does:
>> bpf_jit_alloc_exec()
>> set_vm_flush_reset_perms()
>> set_memory_rox()
>>
>> If the size is greater than the pack size, it calls:
>> bpf_jit_alloc_exec()
>> set_vm_flush_reset_perms()
>> set_memory_rox()
>>
>> So it looks like bpf trampoline is good, and we don't need do anything. It
>> should be removed from the list. I didn't look deep enough for bpf pack
>> allocator in the first place.
>>
>>>>> 2. BPF dispatcher. It calls execmem_alloc which has VM_FLUSH_RESET_PERMS set.
>>>>> But it is used for rw allocation, so VM_FLUSH_RESET_PERMS should be
>>>>> unnecessary IIUC. So it doesn't matter even though vm_reset_perms() fails.
>>>>>
>>>>> 3. kprobe. S390's alloc_insn_page() does call set_memory_rox(), x86 also
>>>>> called set_memory_rox() before switching to execmem cache. The execmem cache
>>>>> calls set_memory_rox(). I don't know why ARM64 doesn't call it.
>>>>>
>>>>> So I think we just need to fix #1 and #3 per the above analysis. If this
>>>>> analysis look correct to you guys, I will prepare two patches to fix them.
>>> This all seems quite fragile. I find it interesting that vm_reset_perms() is
>>> doing break-before-make; it sets the PTEs as invalid, then flushes the TLB, then
>>> sets them to default. But for arm64, at least, I think break-before-make is not
>>> required. We are only changing the permissions so that can be done on live
>>> mappings; essentially change the sequence to; set default, flush TLB.
>> Yeah, I agree it is a little bit fragile. I think this is the "contract" for
>> vmalloc users. You allocate ROX memory via vmalloc, you are required to call
>> set_memory_*(). But there is nothing to guarantee the "contract" is followed.
>> But I don't think this is the only case in kernel.
>>
>>> If we do that, then if the memory was already default, then there is no need to
>>> do anything (so no chance of allocation failure). If the memory was not default,
>>> then it must have already been split to make it non-default, in which case we
>>> can also gurrantee that no allocations are required.
>>>
>>> What am I missing?
>> The comment says:
>> Set direct map to something invalid so that it won't be cached if there are any
>> accesses after the TLB flush, then flush the TLB and reset the direct map
>> permissions to the default.
>>
>> IIUC, it guarantees the direct map can't be cached in TLB after TLB flush from
>> _vm_unmap_aliases() by setting them invalid because TLB never cache invalid
>> entries. Skipping set direct map to invalid seems break this. Or "changing
>> permission on live mappings" on ARM64 can achieve the same goal?
> Here's my understanding of the intent of the code:
>
> Let's say we start with some memory that has been mapped RO. Our goal is to
> reset the memory back to RW and ensure that no TLB entry remains in the TLB for
> the old RO mapping. There are 2 ways to do that:



>
> Approach 1 (used in current code):
> 1. set PTE to invalid
> 2. invalidate any TLB entry for the VA
> 3. set the PTE to RW
>
> Approach 2:
> 1. set the PTE to RW
> 2. invalidate any TLB entry for the VA

IIUC, the intent of the code is "reset direct map permission *without* 
leaving a RW+X window". The TLB flush call actually flushes both VA and 
direct map together.
So if this is the intent, approach #2 may have VA with X permission but 
direct map may be RW at the mean time. It seems break the intent.

Thanks,
Yang

>
> The benefit of approach 1 is that it is guarranteed that it is impossible for
> different CPUs to have different translations for the same VA in their
> respective TLB. But for approach 2, it's possible that between steps 1 and 2, 1
> CPU has a RO entry and another CPU has a RW entry. But that will get fixed once
> the TLB is flushed - it's not really an issue.
>
> (There is probably also an obscure way to end up with 2 TLB entries (one with RO
> and one with RW) for the same CPU, but the arm64 architecture permits that as
> long as it's only a permission mismatch).
>
> Anyway, approach 2 is used when changing memory permissions on user mappings, so
> I don't see why we can't take the same approach here. That would solve this
> whole class of issue for us.
>
> Thanks,
> Ryan
>
>
>> Thanks,
>> Yang
>>
>>> Thanks,
>>> Ryan
>>>
>>>
>>>> Tested the below patch with bpftrace kfunc (allocate bpf trampoline) and
>>>> kprobes. It seems work well.
>>>>
>>>> diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/
>>>> kprobes.c
>>>> index 0c5d408afd95..c4f8c4750f1e 100644
>>>> --- a/arch/arm64/kernel/probes/kprobes.c
>>>> +++ b/arch/arm64/kernel/probes/kprobes.c
>>>> @@ -10,6 +10,7 @@
>>>>
>>>>    #define pr_fmt(fmt) "kprobes: " fmt
>>>>
>>>> +#include <linux/execmem.h>
>>>>    #include <linux/extable.h>
>>>>    #include <linux/kasan.h>
>>>>    #include <linux/kernel.h>
>>>> @@ -41,6 +42,17 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>>>>    static void __kprobes
>>>>    post_kprobe_handler(struct kprobe *, struct kprobe_ctlblk *, struct pt_regs
>>>> *);
>>>>
>>>> +void *alloc_insn_page(void)
>>>> +{
>>>> +       void *page;
>>>> +
>>>> +       page = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
>>>> +       if (!page)
>>>> +               return NULL;
>>>> +       set_memory_rox((unsigned long)page, 1);
>>>> +       return page;
>>>> +}
>>>> +
>>>>    static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
>>>>    {
>>>>           kprobe_opcode_t *addr = p->ainsn.xol_insn;
>>>> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
>>>> index 52ffe115a8c4..3e301bc2cd66 100644
>>>> --- a/arch/arm64/net/bpf_jit_comp.c
>>>> +++ b/arch/arm64/net/bpf_jit_comp.c
>>>> @@ -2717,11 +2717,6 @@ void arch_free_bpf_trampoline(void *image, unsigned int
>>>> size)
>>>>           bpf_prog_pack_free(image, size);
>>>>    }
>>>>
>>>> -int arch_protect_bpf_trampoline(void *image, unsigned int size)
>>>> -{
>>>> -       return 0;
>>>> -}
>>>> -
>>>>    int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *ro_image,
>>>>                                   void *ro_image_end, const struct
>>>> btf_func_model *m,
>>>>                                   u32 flags, struct bpf_tramp_links *tlinks,
>>>>
>>>>
>>>>> Thanks,
>>>>> Yang
>>>>>
>>>>>>> Thanks,
>>>>>>> Ryan
>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Yang
>>>>>>>>
>>>>>>>>> Thanks,
>>>>>>>>> Yang
>>>>>>>>>
>>>>>>>>>> Thanks,
>>>>>>>>>> Ryan
>>>>>>>>>>
>>>>>>>>>>


