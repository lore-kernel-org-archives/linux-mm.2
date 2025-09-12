Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31DB4CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 23:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762828E0002; Fri, 12 Sep 2025 19:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711D98E0001; Fri, 12 Sep 2025 19:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DAC38E0002; Fri, 12 Sep 2025 19:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4AC888E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 19:55:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8ADE13BB93
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:55:36 +0000 (UTC)
X-FDA: 83882257872.15.CB249C6
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2052.outbound.protection.outlook.com [40.107.212.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id ED58C180003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:55:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LdODTL6D;
	spf=pass (imf24.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.212.52 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757721334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/EWc0bDIZlBDvJuzD6yEcZlHIQlaXhobPioEBa7RoZQ=;
	b=Yw7tM46nOjAzWkaQwVOrlAZOdWyt5b52oSaKiahsGCv2KY7jy0xS/lD3oE4tS2KFwbzKEm
	zMYzNOEwg59LJcl9HrISx7MAfUHLyuj7T7xsjLAZbaQMAW0V+9MStFPaS0HvPkLi/vy6EP
	IbWArPNHO/Xw79Ep5fRmwwev24g2qPo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LdODTL6D;
	spf=pass (imf24.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.212.52 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757721334; a=rsa-sha256;
	cv=pass;
	b=otDERqW08K+PZ83QncH39xtVXq0IJgqoes8RdjqJWLKTHjNsebXC83Do+1WI/sIaelAc75
	CWsp/qnTG8yVdvyOyjfjqUm/k0XXBwkYGLP8U8QfHYC4RA75IMHTb9325kvxMsdbDAwWec
	KsR1vHwLd5gSK89jPJD30r7YN37d8jM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q6Lm8grZjnTm6EQv15uLI13ooIoTsHGZtc1/j1yvYjGmf1gbFhkGgf5O/wbfvNXEa58JA126rV/Xo1LSWH7NJ70ot78F+rCKKUSOZChqWTXcWlaDt9hHEKpkHZV7VoLdg6gQt9VhuKUuTea5Bj/gjnhEiJfc7SqDHZEjjaGcHuXZNmfLIoXvAF/wr87D3PiNXX5R9JvPk1ItbmjKEGE7gQtutDjCma0XCvB9dKVTRfMkEr0tHfzMO/2hi2oSAbrQb2CSVyZZ7WDYDKb+2weWgl1tDHtGR852/zYAzL+KGOI3phXzwAq6Q2ztR5k1Wy4Bm+nz2s5c5HHv43cjeOhTUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/EWc0bDIZlBDvJuzD6yEcZlHIQlaXhobPioEBa7RoZQ=;
 b=Rpw5wgd/Phh3nbgQV9qm+s7n0+P1eE6H4Du6HxOC+M5i7O5JUHuagypneEnHQ/cX1Jkg8A5LUrLwMU+cjYDADL7xfO2p3K0SttLVCWrO8+ymWcybdSKS7aCLHinK+EA8V+g51eX532IS+thFiCZGjg3Wms/PHzXRVpqwBJqbjfznBS6w3TFCH9w/z2bO/KDiuAUTA45O/9lCZe9jXJ8jgmSDG0BQZspzHwpVLKI8I34L5v/g7eWLhPMRPv47xhEh1u77fsfwlUqs0BCU/c1931vzmNn4iRFGHCFc7V5/BVPjx5QwtSqSWRoZRzKtjThS/OBLZGldZeVrPsNuGs2DIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/EWc0bDIZlBDvJuzD6yEcZlHIQlaXhobPioEBa7RoZQ=;
 b=LdODTL6DKtBwkHKDN89vf2vKEPIc029jKa84deNnHlCXTdBPbWVIict4IzHgBwNsnoM5zW+J+EmrEZvz/ETtqxJQT5Ma3X/RGZ6NhTLCZF+y0aYpstWrqTqHYBg9b3f6ax0zTPe38aI94Cy8OB577BYn4nmtGeUnlvarea3ZXKQ4PAN+fxjHiCuVNhMXgw4TUae2hcEa8DgxoOdZhNmCUGKK8phx2IAjh3KtQ0JvUb6Ts0CRJUo0i/idpnc2fd+ezxQxaZQ4CElEV/9yJU8I23ItEbTEvmt2TFik8R+zHOzWXLpKPYlhnUYSF/Sn/+1XgO6bSazPuIYkv/8svVg7dA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS7PR12MB5958.namprd12.prod.outlook.com (2603:10b6:8:7d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 23:55:31 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 23:55:30 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: agordeev@linux.ibm.com
Cc: kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	ryabinin.a.a@gmail.com,
	Balbir Singh <balbirs@nvidia.com>
Subject: [PATCH] kasan: Fix warnings caused by use of arch_enter_lazy_mmu_mode()
Date: Sat, 13 Sep 2025 09:55:15 +1000
Message-ID: <20250912235515.367061-1-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY6PR01CA0158.ausprd01.prod.outlook.com
 (2603:10c6:10:1ba::6) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS7PR12MB5958:EE_
X-MS-Office365-Filtering-Correlation-Id: b63226e2-972b-4bdd-5e83-08ddf257dac8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZEFhZ1k0bnUyUnZGaWNvdkg4cVprS0NHYmpIUkFTTWFLeStxV09BWVRKYVlE?=
 =?utf-8?B?TUg4aTB3dDVlQlVtTGt4bDQwNHduSldtTWN1UENVZ2s2K0cyM0o4aFJUazZO?=
 =?utf-8?B?TC9rN0gydnFyalRRS3Y0TWkzWEZqYnF6SXhJelFpZ05WdDAzdmRrRzh4K2c0?=
 =?utf-8?B?WEVGZlRkM3VjbWtMdUJ2ZFRyaHFVak5QQ3ZHUHE3YXQ0Q0dkbmxZZ1BnOTEx?=
 =?utf-8?B?b3dHNW9WZTNPZHFQNDU4TFdiZDMwSlk1Vm1VV1N4L202UnJndXZERWx0aHlY?=
 =?utf-8?B?WE5vcnlVRHFCYk5iT2NtUU9wVmYvNS9Wd1FHR1QrcEZYdnFyVVFaUDE3QjNG?=
 =?utf-8?B?T2VNWUxOM2IxUXBTWGlmZHd5QkQ3d0tSbitmdkNMVEowSTdvajk0d3lNOTRz?=
 =?utf-8?B?TElVMGk4bTR5ZWp4UmFma1kwcUFqM256UUkyZ1VURXFTUy8wMHlEK0hpbzIy?=
 =?utf-8?B?L3FrejRtZHV6em1RQW1FdUxralRFRkRsOVB6emlhM0JhMC9JbW9SRitkK1pp?=
 =?utf-8?B?WFJNRHRsSlVyVEhXUERRL1JtdkNLS01tYjNRdGlXeHE2K1RNNGdLTS9UVS9E?=
 =?utf-8?B?ZHRqT1Z5VXBJa2ovT3diTDhuRW10ang4OXY1bEFMbkc5Yy84SDR3bzJpWTNI?=
 =?utf-8?B?Wkd6WHR1emI4OTNac2tJUWsvd0NTc082RFZDcVNHYVg3dFBzWHdyOXI0elFG?=
 =?utf-8?B?ZnQ3RWJpcTVuVG15MlVEd2tqbTNSVFg1Q1lMR0h1QTdrak93UVRaSkZuN3hQ?=
 =?utf-8?B?TWNRR2c0QTJadzdWYmlyZG1mS2I2Ny81emZ1REZYRytMQmRhbjRLbGliRDBu?=
 =?utf-8?B?UThJL3NNNmNEcHB3Um1CUldJanZOSXo1enRucmlZVUNmc3lpdjFpbU95c05N?=
 =?utf-8?B?ZUowMzVyYVFiY1ZYSld4bXpyOUR6QWFZaVpUWGJyM2NKRk5tWG1lOXEreXhp?=
 =?utf-8?B?UkdhQWdmYmd6NEtXNndkMlA4TFZZczJpZ2ZwVzk4RlB2ZHJvSjlvMk5GSERZ?=
 =?utf-8?B?RFVpK1RSZlFHSVJDaXdDbThHVFNCdENjUFNtd0k5RE4xcVViU3k2VFJ3UnJs?=
 =?utf-8?B?ejN4MVFVRDhmOTRhakRGRnB2dVBySVBjRWR1emo5TmlIWHlFdmZEdzdReTgx?=
 =?utf-8?B?b01OMkpzbjMvbk90UGFMOVpQTmVCbml4WUdRM2hSWGFuS0paWTBBa1lZVTZK?=
 =?utf-8?B?emNUMW12bDh6OWRYd0NaNExKbngyMEp0eVZDS29VTEMxVlV1ZDZFUks0cjhB?=
 =?utf-8?B?eXBVZTFUZHpHQkY3SnE2UmlLS3FFSG44U3Rtem45bkhFaGdZZHFCTFZLbVkr?=
 =?utf-8?B?UEM4U0RhSnY3bkpNSC8vbjRqWGMrRzJzSHBMdzZyRmNROUxnL1VSUUJGbERH?=
 =?utf-8?B?M2VaQXpRRnA2U2c5RFZjRHRiME82S0Z6SGd0RWdRTHhNWW9NaWpENi91Unpy?=
 =?utf-8?B?cGxHL0NSM05JNHlRaUpNOWIyVStnSWkxbTZoTGc5TWs0MDRlOHJrbUhsemRk?=
 =?utf-8?B?QjBHVGY1bHNodWl6YTdlcjA3TUlMUjJtdVQrdkFUSGNJNnI1U2x1ekFjWjdV?=
 =?utf-8?B?Zjg1TXFuUUVYTmtXUXBGSnBwdHJWWjE2NVcybmNSOXN6b1IzNXE4eGJaeGp0?=
 =?utf-8?B?djZkdVpBbExCRHl6WFVmajBxdUFiQmFveWJ3eGtTSEQ3K1g5UmxPbS9Jb3hq?=
 =?utf-8?B?R2M0R21DV3Q0MUFEL056Zm9JbEQyVXo4NmRscjduZVB3N1BTRVIrWjhlL2NF?=
 =?utf-8?B?K2pqSnNxWnJEOWd5UFVqLzVWZGVxaXo1MTdyQk44Z2tybUJWQS9DUzVOTkJ2?=
 =?utf-8?B?Yk91czg3R2tYL1dQa1pWRjZSTmVNTjltcGZuT1E5SndibmJnT1plRmtBdkF4?=
 =?utf-8?B?a2lJYWpZSnd1SDJ1WjcrTStBSzFlcWdQbzZsZjlqNzJoczd6MFlYSm8vWk9I?=
 =?utf-8?Q?TlL8nAkMBd4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z25RTUdFOUpBSlBJTGV4MkR4YXZhT2JBeURvejhuWmE1TWE2T290S1ZMMmV5?=
 =?utf-8?B?bklTT2ZNeTFaV2xpOVhkSmt3bTNPQm1xUjUxRUgveDlMZTN1R1ZsV1F4V0Iv?=
 =?utf-8?B?K1h0dVdSZDNjUVNxdHlOeXYwRkw1M2MveENxY0lzSlhMK0QzUGlkWXZ6ZHEy?=
 =?utf-8?B?d2U2RTBaU3JJc0tWNDEvSWVuVHNYUFZaaEw0MjU5T29kZllVNDJtV05iTlNW?=
 =?utf-8?B?SVhmTEJiSmZ5TVUvaW9kS3E0MjRyYnM2YUpCU05mdUludDZ5L3Z4ajJOMG1k?=
 =?utf-8?B?VXdmR3ZrSXFzTUQyUVU3V0hvQWtrcW9sN2t1ZWxGWE5PY1NCdk5oeTg3Z0tT?=
 =?utf-8?B?M21YQUIrTEljd3FoZGFQQXdmWkloQXRrSFBxRFMzQ3RUVzNXZ3BWV1NmUHZV?=
 =?utf-8?B?NDlTejZEOWx0NHI3UjhxRFJ6c29Vc0pCeTA2Ry9xNzFJZzRsZVdMTm14Qjh2?=
 =?utf-8?B?S2dSTWZRS2lZcTNaSXhNd1hrdElNVkhFZW1ZRU9ua2pEUHNxT1UvYVU1TmYx?=
 =?utf-8?B?TUFhVzkxUlFjb1ljOEp5WjhKcGYwUkZYTUpFNHdyR3RTOUZPeFVrN1lsbEtx?=
 =?utf-8?B?V1FjU0pWSU1ENXFYUHk0UGVtdmIwMzZEUlJDMDJmWFFndWxWbmFNTHFWQjdW?=
 =?utf-8?B?UG9nTnRLY3FuZ2NPNDcyc2ZwVVh1d2duaFBXOE85L2d4YUl4OHhvcnlYQXZO?=
 =?utf-8?B?dVpCWWFTRzFWb3pyN1MrNjJGcHVXbXY3M293Yng4QzVhMTZnVUVGeGRLbTJ4?=
 =?utf-8?B?cXRocGUyRGwxYlViZlJBL21wZk1hd1Z6WFcrdGRFL21CQ3pwK2lackRsQXEv?=
 =?utf-8?B?Y0FUQ0tGMkIzcmU4SGhSWGxIRnBZMnhKY0hKRzYrT2ZRYjF2cXJ4c3pNdldD?=
 =?utf-8?B?djdVaUZVZTc1SVg0aFVXZzczVERUZTR6dzlUN3BYRGQvRFM4YngzZkM1Ukdi?=
 =?utf-8?B?elZ1cE5OOTNZYVpGODlZRUkySWNPUEl6d0NZOFhQME1CRUo0RGtWODk3Mytk?=
 =?utf-8?B?WVRVblhRaVlzeFNybEhDb2x3STFJTURscndFWHBvU29IbFEwV3oxR3VJcmw1?=
 =?utf-8?B?cVFlbHJmc1Y4RVg0anJiUlNzTHIrOGRVTXdRMTcvTmVGV2RkaTZWVDJKTEZm?=
 =?utf-8?B?OGhlWDFldjBzUS8vQ0dOZGtKWGZXeDJnd2tCcnJZdzVIVUc0WG5neDhxSnQx?=
 =?utf-8?B?S3FkZ3RWRTR3RXY0a1dHRjZnYmZ2aGM2MnYxSUZlOS8vSCtNUzdLd2xPWFU1?=
 =?utf-8?B?V2I1cW5FcW5DS0VibElEQ1ZHMEVkWUFzUUE5UTVFSDVjd0ZFZmZkb0plbDdP?=
 =?utf-8?B?TkI3WmpweFk2NmtBN1ordnpHVGo1TGVOa1A4eFV4Uk1rZ2NZT3V5dHZiVkZJ?=
 =?utf-8?B?QUdLZTVrcXBVd091eGRmMUs5OHlXS0ZvV0ZQUjVzSDFuRktCUU1ob09mcW5N?=
 =?utf-8?B?eFhYbXE3M0VKZjZMT0cvUHFTcXNpK0VnNnlxaW05KytaQVVjOGxZVzFqRkZZ?=
 =?utf-8?B?VUtnemJocWIzRVZ5RUpzNnIzWVduUEkyWjJSOStsdVh1dmRRNklZYXdCZVV4?=
 =?utf-8?B?UEYvUjZTQkE4dWw3S0JvMTlmaXVucWp4ZXVJNUs3elNTUUZZU1pZVmtXRVhN?=
 =?utf-8?B?S3FrVlZjQVd3N3l2bGJBcmhJWVBrS1ljVlJSdDBrOEhNOW4xQzcvRFRXMUdz?=
 =?utf-8?B?bTBkZHZkUHFINi9KdVA4d0o5ZkVPcnVselpIU3FDNzZEbXFaMzVvaTIvY3Rw?=
 =?utf-8?B?bFlQWmxySkpKYzlLSm53bzMyNlVyZUF5TnVPWTFXYWoxUDlUS0hKYTZhU29R?=
 =?utf-8?B?MnZOZDVOMWE5dHNUUU8zVEk2bUQyZTVDOXdHUEZJeHZCUzFVcW5RUUR1ajR6?=
 =?utf-8?B?M0hlckVjNEpSODZqeExGdWRmK0ZsQWV5Umg0SUljRnFlZjJmOHpYSFZJSkNJ?=
 =?utf-8?B?K1h3dkY3cWtUT0tyNnIzeWZhajBVMnl4eFM5a2FGM09HbDlBbkw3TjRYL29y?=
 =?utf-8?B?N3VFMmVtcDRTRE1RRGdlcFI4NzYxS081bE1qNmNXUGJ2NTJNRGFmaEJ4UTFu?=
 =?utf-8?B?QTNlaHVCKzl2bldlWWsyNEM0Q3FGQ3FLcHdKZ2UvU2liVUZSd1owLzFxaWhs?=
 =?utf-8?B?S0I1K3g5VkxON09jYTdYbXc1L2x3bGkybzVkRU1UVHF1YTI0NEFkenQ0cGlj?=
 =?utf-8?B?R3c9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b63226e2-972b-4bdd-5e83-08ddf257dac8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 23:55:30.4182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N1ggTZ7GKv53656Z9CLmPhsCpvr0I3wLF1RX5dpMZF3jf2ZeUQxoFbxRl2ovFEnSgW24JBee5CJRgaeDbJxitQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5958
X-Stat-Signature: b4cr4y879aannr61596bu93gg7yina16
X-Rspam-User: 
X-Rspamd-Queue-Id: ED58C180003
X-Rspamd-Server: rspam04
X-HE-Tag: 1757721333-139331
X-HE-Meta: U2FsdGVkX18zSWDk8Q9e1t02MEX1UJruhVs/YWf7uEW5wDWxxluLzew6LKCzj1t0UR2ep7pQxQjHBH/ggzJcV9Vdnzi5MmNYok0zLyWa+Llehne1F+dvLAYwL79YN9jZJhjVEasyhLu9ZzBokqYynmj/WPf5E/f0UOU0A0iKq7kjL6wNm+N3gEMI328k4t7tRpI+x6a3Sy3MBwKitsBIRi9+69m+dFa7VBKgBGX1jr/XMG+vL4Ngttc22MpW7gj8+arNu3YQGFyn0wg1zicRMWKUa+0dO3Mt/Z9xdveGoyEQUhawzFISBFCRLfod7c1f92983uuzFvx3ACgwsl2YdHsl3/1ybIpV1tV246KhdVdn9zSeDtRo69zTVLd/0FxK2nJCSr6UFNZd9OnJdr6bdL3mgG1xHhkhM0TPiWUm5UgRzTHaxYsiaLsmpSWDGLvYLzjVGQ5VfSQd5v1Oisx9Q3/eLwHKMhEMLmPZYCzK0ibaN6S2h+uh04eAxIZe4Ay3RHCfyz05FSrrmvjp7pX4T0/lBhaBZm7GixvaUpLY3mKO2nIp4L3CbTkOOpWX2oaZ06l5brIpzUZw+jxWuUVgUHNuYy5uEZykndlMTaDqjx3mh/HEfIYsTAcf7uWyZ0vOsw8N27JpSkpQFUFsdauKjB0Cz0jTtZU9Ln9Pb3+EfXQveVazwbvGU6OVrp7ZfK33QXdN2ay306grETpwdj/ypreNbZML4UZZsRdQb/7yp3rixuggYxlDH9nZsv4aosf9rdnmdFwCCcDwHrN7fBxAThSQwMLNm3GFhyJmW5/9ykyil6XJqSPOxLOnhclGT/jPc8Q7o3No9jfXnV/hkezsfmFZYg3BBEyYqJn16jRlyc3u5YJoRetWmCh1jckDhSTzaEXWdWusI4OVUKNYL4+xZ7Ec51/FMhQD5+mozGI6bewmQ3d7iJMWdvEhXIu11OdUniXa1j9HSYuA+2M0tY1
 Obh/x57Q
 +clqrVevDuSh9ORIvN/wnP0eTAguRIaboXR+G0VvoG4AB6tTrklKOs5GgXix4NPIQLq3xOFa+OPyu9cZ+LoVU3mYN22uEeHLsGkOyt/i1wig4oMf6VdRfgYVL0rq33gl5tH8keu+sUq2GnrJtJTO52vHstjr0RITl+20NXlS9dXU/Xe6C6eNQVB2KVsvWFiqZOHzhkvzi7xg58tFhqmQosNpPwXz2Bgu693xZkpaNHkmAetkvZccbKM5V6hFVZMydrVIphV35i+YfE5/6kdEkxqu7YLvo+yiUO/QPlo6HI9X8v5rmSB7ZQf9tGKf5f4f/yxONprKbFiG70M+/9m5ng2JdyLPTz2LYpLVh4jXTtJc98mKBqf+UdYHIXVgwn7BySKOZLjun8AU5kmFiJQkekZWM78195iuX3/i6m90lbgKrf9atxV4pmszQLFl2tUWSkS2EXC6KpN8sEcydL5soxYNPObNKmrp0r3AwkK1olRc05F63nx3FKJLTW9E9oA4/YKixEfTvk/wstQSYCJLUFJSmzH8F+aYzqh/TqUmkotqmHJseCAD0AodwQtKwIF9jbiV4veK72pLGczpEW9mXwsePutECJC+LvcwIyDx6ZSs1228J5/35PWR5G0NbUmN/+nqScIk7kT2okT0dwKRkqUBznZSWqWMI0Y7+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit c519c3c0a113 ("mm/kasan: avoid lazy MMU mode hazards") introduced
the use of arch_enter_lazy_mmu_mode(), which results in the compiler
complaining about "statement has no effect", when
__HAVE_ARCH_LAZY_MMU_MODE is not defined in include/linux/pgtable.h

The exact warning/error is:

In file included from ./include/linux/kasan.h:37,
                 from mm/kasan/shadow.c:14:
mm/kasan/shadow.c: In function ‘kasan_populate_vmalloc_pte’:
./include/linux/pgtable.h:247:41: error: statement with no effect [-Werror=unused-value]
  247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
      |                                         ^
mm/kasan/shadow.c:322:9: note: in expansion of macro ‘arch_enter_lazy_mmu_mode’
  322 |         arch_enter_lazy_mmu_mode();
      |         ^~~~~~~~~~~~~~~~~~~~~~~~

Fix the issue by explicitly casting the use of the function to void,
since the returned state is not forwarded/retained

Fixes: c519c3c0a113 ("mm/kasan: avoid lazy MMU mode hazards")
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 mm/kasan/shadow.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 60b1b72f5ce1..347e02a70892 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -319,7 +319,7 @@ static int kasan_populate_vmalloc_pte(pte_t *ptep, unsigned long addr,
 	}
 	spin_unlock(&init_mm.page_table_lock);
 
-	arch_enter_lazy_mmu_mode();
+	(void)arch_enter_lazy_mmu_mode();
 
 	return 0;
 }
@@ -494,7 +494,7 @@ static int kasan_depopulate_vmalloc_pte(pte_t *ptep, unsigned long addr,
 	if (likely(!none))
 		__free_page(pfn_to_page(pte_pfn(pte)));
 
-	arch_enter_lazy_mmu_mode();
+	(void)arch_enter_lazy_mmu_mode();
 
 	return 0;
 }
-- 
2.50.1


